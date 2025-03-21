#!/usr/bin/env ruby

# This script monkey patches the HerokuRubyInstaller class to use a pre-compiled Ruby
# instead of downloading it from Heroku's servers

# Add language_pack to load path
$:.unshift File.expand_path("../../lib", __FILE__)
$:.unshift File.expand_path("../../../lib", __FILE__)

require "language_pack/installers/heroku_ruby_installer"

# Monkey patch the HerokuRubyInstaller class
module LanguagePack
  module Installers
    class HerokuRubyInstaller
      # Save the original install method
      alias_method :original_install, :install
      
      # Override the install method
      def install(ruby_version, install_dir)
        # Only override for Ruby 2.5.8
        if ruby_version.version_for_download.include?("ruby-2.5.8")
          puts "-----> Using pre-compiled Ruby 2.5.8"
          
          # Create the install directory if it doesn't exist
          FileUtils.mkdir_p(install_dir)
          
          # Copy your pre-compiled Ruby to the install directory
          # Assuming your pre-compiled Ruby is in /app/.heroku/ruby-2.5.8
          if File.directory?("/app/.heroku/ruby-2.5.8")
            puts "-----> Copying pre-compiled Ruby 2.5.8 from /app/.heroku/ruby-2.5.8"
            FileUtils.cp_r("/app/.heroku/ruby-2.5.8/.", install_dir)
          else
            # Fall back to the original method if the pre-compiled Ruby is not found
            puts "-----> Pre-compiled Ruby 2.5.8 not found, falling back to original method"
            return original_install(ruby_version, install_dir)
          end
          
          # Set up binstubs
          setup_binstubs(install_dir)
        else
          # For other Ruby versions, use the original method
          original_install(ruby_version, install_dir)
        end
      end
    end
  end
end

puts "-----> Ruby installer patched to use pre-compiled Ruby 2.5.8"
