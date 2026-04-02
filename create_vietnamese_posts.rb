#!/usr/bin/env ruby
# frozen_string_literal: true

# Script to create Vietnamese versions of blog posts
# Usage: ruby create_vietnamese_posts.rb

require 'fileutils'
require 'yaml'

# Directory paths
POSTS_DIR = '_posts'
VI_POSTS_DIR = 'vi/_posts'

# Ensure Vietnamese posts directory exists
FileUtils.mkdir_p(VI_POSTS_DIR)

# Get all English posts
english_posts = Dir.glob("#{POSTS_DIR}/*.md").sort

puts "Found #{english_posts.length} English posts"
puts "Creating Vietnamese versions...\n"

english_posts.each do |english_post|
  filename = File.basename(english_post)
  vi_post_path = File.join(VI_POSTS_DIR, filename)

  # Skip if Vietnamese version already exists
  if File.exist?(vi_post_path)
    puts "⏭️  Skipping #{filename} (Vietnamese version already exists)"
    next
  end

  # Read English post
  content = File.read(english_post)

  # Parse front matter and content
  if content =~ /\A(---\s*\n.*?\n?)^(---\s*$\n?)/m
    front_matter = YAML.load($1)
    post_content = $'

    # Update front matter for Vietnamese
    front_matter['lang'] = 'vi'
    front_matter['ref'] = filename.gsub(/^\d{4}-\d{2}-\d{2}-/, '').gsub('.md', '')

    # Add translation note to content
    vi_content = "#{front_matter.to_yaml}---\n\n"
    vi_content += "> **📝 Lưu ý**: Đây là phiên bản tiếng Việt. Vui lòng dịch nội dung bên dưới.\n\n"
    vi_content += post_content

    # Write Vietnamese version
    File.write(vi_post_path, vi_content)
    puts "✅ Created #{filename}"
  else
    puts "❌ Could not parse #{filename}"
  end
end

puts "\n✨ Done! Vietnamese post templates created in #{VI_POSTS_DIR}"
puts "\n📝 Next steps:"
puts "1. Go to #{VI_POSTS_DIR}"
puts "2. Translate the content in each file"
puts "3. Update titles, subtitles, and tags to Vietnamese"
puts "4. Commit and push your changes"
