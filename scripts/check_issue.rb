#!/usr/bin/env ruby
# Checks a student newsletter issue before it is published.
# Usage: ruby scripts/check_issue.rb _issues/2026-11-11-week-11.md
# Exits 1 and lists problems if anything is wrong; prints "OK" and word counts otherwise.
require "yaml"
require "date"

# Length limits keep every issue a ~3-minute read.
MAX_TOTAL_WORDS   = 450 # whole issue, not counting the prompt itself
MAX_SECTION_WORDS = 120 # any one section, not counting the prompt
MAX_LINE_WORDS    = 30  # this_week and challenge

SECTIONS = {
  "The Big Picture" => /\A## The Big Picture\s*\z/,
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
if text.include?("YYYY-MM-DD") || text.include?("https://example.com") || text =~ /Short headline for this week/
  problems << "Template placeholder text or links are still in the file"
end

# Split the body into "## " sections.
chunks = body.split(/^(?=## )/).map(&:strip).reject(&:empty?)
headings = chunks.map { |c| c.lines.first.strip }

SECTIONS.each_with_index do |(name, pattern), i|
  found = headings.index { |h| h =~ pattern }
  if found.nil?
    problems << "Missing or misnamed section '#{name}' (see _templates/issue-template.md for allowed headings)"
  elsif found != i
    problems << "Section '#{name}' is out of order; the order is: #{SECTIONS.keys.join(', ')}"
  end
end
extra = headings.reject { |h| SECTIONS.values.any? { |p| h =~ p } }
extra.each { |h| problems << "Unexpected section '#{h}'. Only the four standard sections are allowed" }

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
  when /Try This/
    problems << "Try This needs the prompt in a ```text block" unless content =~ /```text\n.+?```/m
    problems << "Try This needs a '**What to look for:**' line" unless content.include?("**What to look for:**")
  when /Is This OK/
    problems << "Is This OK? needs a '**My answer:**' line" unless content.include?("**My answer:**")
  end
end
problems << "Issue is #{total} words; keep it to #{MAX_TOTAL_WORDS} or fewer" if total > MAX_TOTAL_WORDS

if problems.empty?
  puts "OK: #{path} (#{total} words, about #{total / 200 + 1} min read)"
  counts.each { |h, n| puts "  #{n.to_s.rjust(4)}  #{h}" }
else
  puts "Problems in #{path}:"
  problems.each { |p| puts "  - #{p}" }
  exit 1
end
