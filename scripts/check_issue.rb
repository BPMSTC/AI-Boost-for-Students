#!/usr/bin/env ruby
# Checks a student newsletter issue before it is published.
# Usage: ruby scripts/check_issue.rb _issues/2026-11-11-week-11.md
# Exits 1 and lists problems if anything is wrong; prints "OK" and word counts otherwise.
require "yaml"
require "date"

# Length limits keep every issue a ~3-minute read.
MAX_TOTAL_WORDS   = 530 # whole issue, not counting the prompt itself
MAX_SECTION_WORDS = 120 # any one section, not counting the prompt
MAX_ALSO_WORDS    = 80  # "Also This Week" is a short second story
MAX_LINE_WORDS    = 30  # this_week, challenge, and image_alt

# Issues dated before this used the original four-section format (450 words, no
# "Also This Week"). They are still checked against that format so they keep passing.
FIVE_SECTION_START = Date.new(2026, 11, 5)
OLD_MAX_TOTAL_WORDS = 450

# Optional image: stored in this folder, named in front matter, kept small for phones.
IMAGE_DIR       = "assets/images/issues"
IMAGE_TYPES     = %w[.jpg .jpeg .png .webp .gif].freeze
MAX_IMAGE_BYTES = 300 * 1024

SECTIONS = {
  "The Big Picture" => /\A## The Big Picture\s*\z/,
  "Also This Week"  => /\A## Also This Week\s*\z/,
  "Level Up"        => /\A## Level Up: (Word of the Week|Myth vs\. Fact|Spot the Fake)\s*\z/,
  "Try This"        => /\A## Try This\s*\z/,
  "Is This OK?"     => /\A## Is This OK\? (Academic Honesty|Privacy)\s*\z/
}.freeze

def words(text)
  text.gsub(/\[([^\]]*)\]\([^)]*\)/, '\1')   # count link text, not URLs
      .gsub(/[#*`>_]/, " ")
      .split.size
end

path = ARGV[0] or abort("Usage: ruby scripts/check_issue.rb <issue-file>")
text = File.read(path, encoding: "UTF-8")
problems = []

unless File.basename(path) =~ /\A\d{4}-\d{2}-\d{2}-[a-z0-9-]+\.md\z/
  problems << "File name must look like YYYY-MM-DD-short-name.md (lowercase, dashes)"
end

match = text.match(/\A---\n(.*?)\n---\n(.*)\z/m)
abort("Problems in #{path}:\n  - Missing front matter block (--- ... ---) at the top") unless match
front = YAML.safe_load(match[1], permitted_classes: [Date]) || {}
body = match[2]

%w[title issue date semester this_week challenge].each do |key|
  problems << "Front matter is missing '#{key}'" if front[key].to_s.strip.empty?
end
if front["date"] && File.basename(path)[0, 10] != front["date"].to_s
  problems << "'date' (#{front['date']}) doesn't match the date in the file name"
end
%w[this_week challenge].each do |key|
  n = words(front[key].to_s)
  problems << "'#{key}' is #{n} words; keep it to #{MAX_LINE_WORDS} or fewer" if n > MAX_LINE_WORDS
end
# Older issues use the four-section format.
issue_date = (Date.parse(front["date"].to_s) rescue nil)
five_sections = issue_date.nil? || issue_date >= FIVE_SECTION_START
sections = five_sections ? SECTIONS : SECTIONS.reject { |k, _| k == "Also This Week" }
max_total = five_sections ? MAX_TOTAL_WORDS : OLD_MAX_TOTAL_WORDS

# Optional image: if 'image' is set, it needs alt text and a credit, and the file must exist.
image = front["image"].to_s.strip
if image.empty?
  %w[image_alt image_credit].each do |key|
    problems << "'#{key}' is set but 'image' is not; add the image or remove '#{key}'" unless front[key].to_s.strip.empty?
  end
else
  root = File.expand_path("..", __dir__)
  file = File.join(root, IMAGE_DIR, image)
  if image.include?("/")
    problems << "'image' should be just the file name (e.g. 2026-11-11-week-11.jpg), stored in #{IMAGE_DIR}/"
  elsif !IMAGE_TYPES.include?(File.extname(image).downcase)
    problems << "'image' must be one of: #{IMAGE_TYPES.join(', ')}"
  elsif !File.exist?(file)
    problems << "Image file #{IMAGE_DIR}/#{image} doesn't exist"
  elsif File.size(file) > MAX_IMAGE_BYTES
    problems << "Image is #{File.size(file) / 1024} KB; keep it under #{MAX_IMAGE_BYTES / 1024} KB so it loads fast on phones " \
                "(e.g. convert in.png -resize 1200x\\> -quality 80 out.jpg)"
  end
  alt = front["image_alt"].to_s.strip
  if alt.empty?
    problems << "'image_alt' is required with an image: one sentence describing it for screen readers"
  elsif words(alt) > MAX_LINE_WORDS
    problems << "'image_alt' is #{words(alt)} words; keep it to #{MAX_LINE_WORDS} or fewer"
  end
  if front["image_credit"].to_s.strip.empty?
    problems << "'image_credit' is required with an image, e.g. 'Screenshot by Brent Presley' or 'AI-generated with <tool>'"
  end
end
if body =~ /!\[[^\]]*\]\(/
  problems << "Don't put images in the body; use the 'image', 'image_alt', and 'image_credit' front matter instead"
end

if text.include?("YYYY-MM-DD") || text.include?("https://example.com") || text =~ /Short headline for this week/
  problems << "Template placeholder text or links are still in the file"
end

# Split the body into "## " sections.
chunks = body.split(/^(?=## )/).map(&:strip).reject(&:empty?)
headings = chunks.map { |c| c.lines.first.strip }

positions = sections.map do |name, pattern|
  found = headings.index { |h| h =~ pattern }
  problems << "Missing or misnamed section '#{name}' (see _templates/issue-template.md for allowed headings)" if found.nil?
  found
end
found_positions = positions.compact
if found_positions != found_positions.sort
  problems << "Sections are out of order; the order is: #{sections.keys.join(', ')}"
end
extra = headings.reject { |h| sections.values.any? { |p| h =~ p } }
extra.each { |h| problems << "Unexpected section '#{h}'. Only the #{sections.size} standard sections are allowed" }

total = 0
counts = {}
chunks.each do |chunk|
  heading = chunk.lines.first.strip
  content = chunk.lines.drop(1).join
  prose = content.gsub(/```.*?```/m, "")
  n = words(prose)
  total += n
  counts[heading] = n
  problems << "'#{heading}' is #{n} words; keep it to #{MAX_SECTION_WORDS} or fewer" if n > MAX_SECTION_WORDS
  problems << "'#{heading}' needs exactly one ### headline" unless content.scan(/^### /).size == 1

  case heading
  when /The Big Picture/
    problems << "The Big Picture needs a link to the story" unless content =~ /\]\(https?:\/\//
    problems << "The Big Picture needs a '**Why it matters to you:**' line" unless content.include?("**Why it matters to you:**")
  when /Also This Week/
    problems << "Also This Week needs a link to the story" unless content =~ /\]\(https?:\/\//
    problems << "'#{heading}' is #{n} words; keep it to #{MAX_ALSO_WORDS} or fewer" if n > MAX_ALSO_WORDS
  when /Try This/
    problems << "Try This needs the prompt in a ```text block" unless content =~ /```text\n.+?```/m
    problems << "Try This needs a '**What to look for:**' line" unless content.include?("**What to look for:**")
  when /Is This OK/
    problems << "Is This OK? needs a '**My answer:**' line" unless content.include?("**My answer:**")
  end
end
problems << "Issue is #{total} words; keep it to #{max_total} or fewer" if total > max_total

if problems.empty?
  puts "OK: #{path} (#{total} words, about #{total / 200 + 1} min read)"
  counts.each { |h, n| puts "  #{n.to_s.rjust(4)}  #{h}" }
else
  puts "Problems in #{path}:"
  problems.each { |p| puts "  - #{p}" }
  exit 1
end
