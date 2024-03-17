#!/usr/bin/env ruby
# frozen_string_literal: true

require 'fileutils'

openscad_bin = '/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD'
build_dir = 'build_single'

('A'..'Z').each do |letter|
  filename = "organizer_#{letter}.stl"
  filepath = "./#{build_dir}/#{filename}"

  if File.exist?(filepath)
    puts "=> #{filename} already exists..."
    next
  end

  puts "=> Rendering #{filename}..."
  system(openscad_bin,
         '-D', "letter=\"#{letter}\"",
         '--render',
         '-o', filepath,
         'organizer.scad')
end
