# This is strongly inspired by (and much code was lifted from) the incredible:
# https://github.com/mattbrictson/rails-template
require "bundler"

def assert_ruby_version(required_ruby_version)
  current_ruby_version = RUBY_VERSION
  assert_minimum_version(required_ruby_version, current_ruby_version, "Ruby")
end

def assert_rails_version(required_rails_version)
  current_rails_version = Rails::VERSION::STRING
  assert_minimum_version(required_rails_version, current_rails_version, "Rails")
end

def assert_yarn_version(required_yarn_version)
  current_yarn_version = `yarn -v`.strip
  assert_minimum_version(required_yarn_version, current_yarn_version, "Yarn")
rescue Errno::ENOENT => e
  message = if e.message.include?("No such file or directory - yarn")
    "Yarn is not installed! Visit: https://yarnpkg.com/lang/en/docs/install/"
  else
    message = e.message
  end

  puts message.red
  exit 1
end

def assert_minimum_version(required_version, current_version, lib_name)
  print "Checking #{lib_name} version is #{required_version}... ".yellow
  # using Gem to compare version strings, even if the target isn't a gem
  requirement = Gem::Requirement.new(required_version)
  actual_version = Gem::Version.new(current_version)

  if requirement.satisfied_by?(actual_version)
    puts "✓".green
    return
  else
    puts "FAIL".red
  end

  exit 1 if no?(%Q(
    This template requires #{lib_name} #{required_version}.
    You are using #{current_version}. Continue anyway?
  ), :yellow)
end

def assert_valid_options
  # rails new accepts many options, but our template handles a bunch of stuff
  # automatically so warn if those options are specified differently
  valid_options = {
    skip_gemfile: false,
    skip_bundle: false,
    skip_git: false,
    skip_test_unit: false,
    edge: false
  }
  valid_options.each do |key, expected|
    next unless options.key?(key)
    actual = options[key]
    unless actual == expected
      fail Rails::Generators::Error, "Unsupported option: #{key}=#{actual}"
    end
  end
end

def assert_postgres
  return if IO.read("Gemfile") =~ /^\s*gem ['"]pg['"]/
  fail Rails::Generators::Error, <<-POSTGRES

    We always use PostgreSQL, but the pg gem isn’t present in your Gemfile.
    Make sure you run `rails new` with the `-d postgresql` flag.
  POSTGRES
end

# Extend string with some Terminal color helpers
class String
  def red;        "\e[31m#{self}\e[0m" end
  def green;      "\e[32m#{self}\e[0m" end
  def yellow;     "\e[33m#{self}\e[0m" end
  def blue;       "\e[34m#{self}\e[0m" end
  def magenta;    "\e[35m#{self}\e[0m" end

  def bg_red;     "\e[41m#{self}\e[0m" end
  def bg_green;   "\e[42m#{self}\e[0m" end
  def bg_blue;    "\e[44m#{self}\e[0m" end
  def bg_magenta; "\e[45m#{self}\e[0m" end
  def bg_cyan;    "\e[46m#{self}\e[0m" end
  def bg_gray;    "\e[47m#{self}\e[0m" end

  def bold;       "\e[1m#{self}\e[22m" end
  def italic;     "\e[3m#{self}\e[23m" end
  def underline;  "\e[4m#{self}\e[24m" end
end
