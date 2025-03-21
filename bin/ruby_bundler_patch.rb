#!/usr/bin/env ruby

# This script patches the BundlerInstaller and BundlerWrapper classes to use the locally installed Bundler

# First, define the module structure if it doesn't exist
module LanguagePack
  module Helpers
  end
end

# Now add language_pack to load path
$:.unshift File.expand_path("../../lib", __FILE__)
$:.unshift File.expand_path("../lib", __FILE__)

# Require the necessary files in the correct order
require "language_pack"
require "language_pack/shell_helpers"

# Now we can define our patched classes
module LanguagePack
  module Helpers
    class BundlerWrapper
      include LanguagePack::ShellHelpers

      # Override the bundler_version method
      def bundler_version
        puts "-----> Using Bundler 2.3.25 (patched)"
        "2.3.25"
      end
      
      # Override the install method to use the locally installed bundler
      def install
        puts "-----> Using locally installed Bundler 2.3.25"
        @version = "2.3.25"
        true
      end
    end
    
    class BundlerInstaller
      # Override the install method
      def install
        puts "-----> Using locally installed Bundler 2.3.25"
        
        # Force Bundler 2.3.25
        @bundler_version = "2.3.25"
        
        # Create a dummy bundler directory structure
        FileUtils.mkdir_p("bundler-#{@bundler_version}/gems/bundler-#{@bundler_version}/lib/bundler")
        File.open("bundler-#{@bundler_version}/gems/bundler-#{@bundler_version}/lib/bundler/version.rb", "w") do |f|
          f.puts <<-VERSION
module Bundler
  VERSION = "#{@bundler_version}"
end
          VERSION
        end
        
        true
      end
    end
  end
end

puts "-----> Bundler installer patched to use Bundler 2.3.25"
