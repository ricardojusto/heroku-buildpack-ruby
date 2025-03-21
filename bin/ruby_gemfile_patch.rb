#!/usr/bin/env ruby

# This script updates the Gemfile.lock to use Bundler 2.3.25

build_dir = ARGV[0]
gemfile_lock_path = "#{build_dir}/Gemfile.lock"

if File.exist?(gemfile_lock_path)
  puts "-----> Updating Gemfile.lock to use Bundler 2.3.25"
  
  # Read the Gemfile.lock
  gemfile_lock = File.read(gemfile_lock_path)
  
  # Update the BUNDLED WITH section
  if gemfile_lock.include?("BUNDLED WITH")
    gemfile_lock = gemfile_lock.gsub(/BUNDLED WITH\s+\d+\.\d+\.\d+/, "BUNDLED WITH\n   2.3.25")
  else
    gemfile_lock += "\nBUNDLED WITH\n   2.3.25\n"
  end
  
  # Write the updated Gemfile.lock
  File.write(gemfile_lock_path, gemfile_lock)
  
  puts "-----> Gemfile.lock updated to use Bundler 2.3.25"
else
  puts "-----> Gemfile.lock not found"
end
