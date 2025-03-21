#!/usr/bin/env ruby

# This script patches the Ruby class to use our pre-compiled Ruby 2.5.8

# First, define the module structure if it doesn't exist
module LanguagePack
end

# Add language_pack to load path
$:.unshift File.expand_path("../../lib", __FILE__)
$:.unshift File.expand_path("../lib", __FILE__)

# Require the necessary files
require "language_pack"
require "language_pack/ruby"

# Monkey patch the Ruby class
class LanguagePack::Ruby
  # Save the original install_ruby method
  alias_method :original_install_ruby, :install_ruby
  
  # Override the install_ruby method
  def install_ruby(install_dir)
    # Check if we're trying to install Ruby 2.5.8
    if ruby_version.version == "ruby-2.5.8"
      puts "-----> Using pre-compiled Ruby 2.5.8"
      
      # Get the build directory
      build_dir = ENV['BUILD_DIR'] || build_path
      
      # Check if our pre-compiled Ruby exists
      if File.directory?("#{build_dir}/.heroku/ruby")
        puts "-----> Copying pre-compiled Ruby 2.5.8 to #{install_dir}"
        
        # Create the install directory if it doesn't exist
        FileUtils.mkdir_p(install_dir)
        
        # Copy our pre-compiled Ruby to the install directory
        FileUtils.cp_r("#{build_dir}/.heroku/ruby/.", install_dir)
        
        # Make sure the binaries are executable
        Dir["#{install_dir}/bin/*"].each do |path|
          FileUtils.chmod(0755, path)
        end
        
        return true
      else
        puts "-----> Pre-compiled Ruby 2.5.8 not found, falling back to original method"
        return original_install_ruby(install_dir)
      end
    else
      # For other Ruby versions, use the original method
      original_install_ruby(install_dir)
    end
  end
end

puts "-----> Ruby installer patched to use pre-compiled Ruby 2.5.8"
