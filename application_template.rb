# This is strongly inspired by (and much code was lifted from) the incredible:
# https://github.com/mattbrictson/rails-template
require "bundler"

# Constants
RUBY_VERSION_REQUIREMENT = "~> 2.6.1".freeze
RAILS_VERSION_REQUIREMENT = "~> 6.0.0".freeze
YARN_VERSION_REQUIREMENT = "~> 1.19.1".freeze

# Main template
def lets_go!
  # Sanity checks
  assert_ruby_version(RUBY_VERSION_REQUIREMENT)
  assert_rails_version(RAILS_VERSION_REQUIREMENT)
  assert_yarn_version(YARN_VERSION_REQUIREMENT)
  assert_valid_options
  assert_postgres

  # Prepare the application file templates
  add_template_repository_to_source_path

  confirm_optional_libs

  template "Gemfile.tt", force: true
  template "README.md.tt", force: true
  template "example.env.tt"

  copy_file "gitignore", ".gitignore", force: true
  copy_file "ruby-version", ".ruby-version", force: true
end

# Helper methods
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

  puts red(message)
  exit 1
end

def assert_minimum_version(required_version, current_version, lib_name)
  print yellow("Checking #{lib_name} version #{current_version} satisfies #{required_version}... ")
  # using Gem to compare version strings, even if the target isn't a gem
  requirement = Gem::Requirement.new(required_version)
  actual_version = Gem::Version.new(current_version)

  if requirement.satisfied_by?(actual_version)
    puts green("✓")
    return
  else
    puts red("FAIL")
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
    skip_test: false,
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

# Add this template directory to source_paths so that Thor actions like
# copy_file and template resolve against our source files. If this file was
# invoked remotely via HTTP, that means the files are not present locally.
# In that case, use `git clone` to download them to a local temporary dir.
def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://} # Was a URL specified?
    print yellow("Cloning Siderail... ")

    require "fileutils"
    require "shellwords"
    require "tmpdir"

    # Make a temp directory and add it to the source paths
    source_paths.unshift(tempdir = Dir.mktmpdir("siderail-"))
    # Delete the temp dir when we're done
    at_exit { FileUtils.remove_entry(tempdir) }
    # Clone the template repo into the temp directory
    git clone: [
      "--quiet",
      "https://github.com/PolarNotion/siderail.git",
      tempdir
    ].map(&:shellescape).join(" ")

    puts red(__FILE__)

    # If there's a branch name in the given template file...
    if (branch = __FILE__[%r{siderail/(.+)/application_template.rb}, 1])
      # check out that branch
      Dir.chdir(tempdir) { git checkout: branch }
    end
  else # Local file specified? Add its directory to source paths
    print yellow("Using local directory... ")
    source_paths.unshift(File.dirname(__FILE__))
  end
  puts green("✓")
end

def confirm_optional_libs
  puts yellow("Select Options:")
  sidekiq?
  redis?
  image_uploads?
end

def sidekiq?
  @sidekiq ||= yes?(yellow("Sidekiq?"))
end

def redis?
  @redis ||= sidekiq? || yes?(yellow("Redis?"))
end

def image_uploads?
  @image_uploads ||= yes?(yellow("Image Uploads?"))
end

# Terminal color helpers
def colorize(str, clr_num); "\e[#{clr_num}m#{str}\e[0m"; end
def red(str); colorize(str, 31); end
def green(str); colorize(str, 32); end
def yellow(str); colorize(str, 33); end

lets_go!
