#!/usr/bin/env ruby
# Checks a newsletter issue file before it is published.
# Usage: ruby scripts/check_issue.rb _issues/2026-11-04-week-10.md
# Exits 1 and lists problems if anything is wrong; prints "OK" otherwise.
require "yaml"
require "date"

path = ARGV[0] or abort("Usage: ruby scripts/check_issue.rb <issue-file>")
text = File.read(path, encoding: "UTF-8")
problems = []

unless File.basename(path) =~ /\A\d{4}-\d{2}-\d{2}-[a-z0-9-]+\.md\z/
  problems << "File name must look like YYYY-MM-DD-short-name.md (lowercase, dashes)"
end

match = text.match(/\A---\n(.*?)\n---\n/m)
if match.nil?
  problems << "Missing front matter block (--- ... ---) at the top"
  front = {}
else
  front = YAML.safe_load(match[1], permitted_classes: [Date]) || {}
end

%w[Issue\ Date Issue\ Number Title date semester].each do |key|
  problems << "Front matter is missing '#{key}'" if front[key].to_s.strip.empty?
end
if front["Issue Date"].to_s != front["date"].to_s
  problems << "'Issue Date' and 'date' must match"
end
if front["Title"].to_s.include?("One-line headline") || text.include?("YYYY-MM-DD")
  problems << "Template placeholder text is still in the file"
end
if text.include?("https://example.com")
  problems << "Placeholder link https://example.com is still in the file"
end

required = ["Quick Scan", "Try This", "Follow-up heading", "Follow-up tasks"]
required.each do |section|
  problems << "Missing section '## #{section}'" unless text =~ /^## #{Regexp.escape(section)}/
end

# Every "- **Title:**" item needs a URL unless it is in a section that allows none.
text.scan(/^- \*\*Title:\*\*.*?(?=^- |^## |\z)/m).each do |item|
  title = item[/\*\*Title:\*\*\s*(.+)/, 1]
  problems << "Item '#{title}' has no **URL:**" unless item.include?("**URL:**")
end

image_dir = File.join("assets/images/issues", File.basename(path, ".md"))
text.scan(/\*\*(?:ArticleImage|Image):\*\*\s*(\S+)/).flatten.each do |img|
  next if img.start_with?("http")
  full = File.join(image_dir, img)
  problems << "Image not found: #{full}" unless File.exist?(full)
end

if problems.empty?
  puts "OK: #{path}"
else
  puts "Problems in #{path}:"
  problems.each { |p| puts "  - #{p}" }
  exit 1
end
