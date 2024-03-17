#!/usr/bin/env ruby
# frozen_string_literal: true

require 'fileutils'

openscad_bin = '/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD'
build_dir = 'build_multi'
letter_groups = %w[A-C D-E F-H I-L M-O P-R S-T U-Z]

letter_groups.each do |group|
  filename = "#{group}.stl"
  filepath = File.join(build_dir, filename)

  if File.exist?(filepath)
    puts "=> #{filename} already exists..."
    next
  end

  puts "=> Rendering #{filename}..."
  system("#{openscad_bin} -D \"chars=\\\"#{group}\\\"\" --render -o \"#{filepath}\" organizer.scad")
end
