require "language_pack/ruby"

class LanguagePack::CustomRuby < LanguagePack::Ruby
  # Override the ruby_version method to always return our custom version
  def ruby_version
    @ruby_version ||= LanguagePack::RubyVersion.new("ruby-2.5.8")
  end

  # Override the install_ruby method to use our custom Ruby
  def install_ruby(install_path)
    puts "Using pre-compiled Ruby 2.5.8"
    # The actual installation is done in bin/compile
    true
  end

  # Override bundler to use our specific version
  def self.bundler
    @@bundler ||= LanguagePack::Helpers::BundlerWrapper.new.install
    @@bundler.version = "1.17.3"
    @@bundler
  end

  # Skip the outdated Ruby warnings
  def warn_outdated_ruby
    puts 'Skipping outdated Ruby warning'
  end
end
