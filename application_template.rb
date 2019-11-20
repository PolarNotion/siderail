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

  # project root configuration files
  template "Gemfile.tt", force: true
  template "README.md.tt", force: true
  template "example.env.tt"

  copy_file "gitignore", ".gitignore", force: true
  copy_file "ruby-version", ".ruby-version", force: true
  copy_file "Guardfile", "Guardfile"

  # app/
  copy_file "app/assets/images/default-profile-photo.png", force: true
  copy_file "app/assets/images/spacer-landscape.png", force: true
  copy_file "app/assets/images/spacer-portrait.png", force: true
  copy_file "app/assets/javascripts/general.coffee", force: true
  copy_file "app/assets/stylesheets/admin.scss", force: true
  copy_file "app/assets/stylesheets/application.css", force: true
  copy_file "app/assets/stylesheets/styles.scss", force: true
  copy_file "app/assets/stylesheets/variables.scss", force: true
  copy_file "app/controllers/admin/admin_base_controller.rb", force: true
  copy_file "app/controllers/admin/pages_controller.rb", force: true
  copy_file "app/controllers/admin/settings_controller.rb", force: true
  copy_file "app/controllers/admin/users_controller.rb", force: true
  copy_file "app/controllers/application_controller.rb", force: true
  copy_file "app/controllers/pages_controller.rb", force: true
  copy_file "app/helpers/application_helper.rb", force: true
  copy_file "app/models/ahoy/event.rb", force: true
  copy_file "app/models/ahoy/visit.rb", force: true
  copy_file "app/models/setting.rb", force: true
  copy_file "app/models/user.rb", force: true
  copy_file "app/users/confirmations_controller.rb", force: true
  copy_file "app/users/omniauth_callbacks_controller.rb", force: true
  copy_file "app/users/passwords_controller.rb", force: true
  copy_file "app/users/registrations_controller.rb", force: true
  copy_file "app/users/sessions_controller.rb", force: true
  copy_file "app/users/unlocks_controller.rb", force: true
  copy_file "app/views/admin/pages/dashboard.html.haml", force: true
  copy_file "app/views/admin/pages/entries.html.haml", force: true
  copy_file "app/views/admin/pages/utilities.html.haml", force: true
  copy_file "app/views/admin/settings/index.html.haml", force: true
  copy_file "app/views/admin/users/index.html.haml", force: true
  copy_file "app/views/layouts/_alerts.html.haml", force: true
  copy_file "app/views/layouts/_breadcrumbs.html.haml", force: true
  copy_file "app/views/layouts/_footer.html.haml", force: true
  copy_file "app/views/layouts/_head.html.haml", force: true
  copy_file "app/views/layouts/_navigation.html.haml", force: true
  copy_file "app/views/layouts/admin.html.haml", force: true
  copy_file "app/views/layouts/application.html.haml", force: true
  copy_file "app/views/layouts/mailer.html.haml", force: true
  copy_file "app/views/layouts/mailer.text.haml", force: true
  copy_file "app/views/pages/home.html.haml", force: true
  copy_file "app/views/shared/search/_form.html.haml", force: true
  copy_file "app/views/users/confirmations/new.html.haml", force: true
  copy_file "app/views/users/mailer/confirmation_instructions.html.haml", force: true
  copy_file "app/views/users/mailer/email_changed.html.haml", force: true
  copy_file "app/views/users/mailer/password_change.html.haml", force: true
  copy_file "app/views/users/mailer/reset_password_instructions.html.haml", force: true
  copy_file "app/views/users/mailer/unlock_instructions.html.haml", force: true
  copy_file "app/views/users/passwords/edit.html.haml", force: true
  copy_file "app/views/users/passwords/new.html.haml", force: true
  copy_file "app/views/users/registrations/_details.html.haml", force: true
  copy_file "app/views/users/registrations/edit.html.haml", force: true
  copy_file "app/views/users/registrations/new.html.haml", force: true
  copy_file "app/views/users/sessions/new.html.haml", force: true
  copy_file "app/views/users/shared/_error_messages.html.haml", force: true
  copy_file "app/views/users/shared/_links.html.haml", force: true
  copy_file "app/views/users/unlocks/new.html.haml", force: true

  Dir["app/views/**/*.erb"].each do |filename|
    File.delete(filename)
  end

  # config/
  copy_file "config/application.rb", force: true
  copy_file "config/routes.rb", force: true
  template "config/storage.yml.tt", force: true

  # config/environments
  environment env: "development" do
    """
      config.action_mailer.default_url_options   = { host: 'lvh.me', port: 3000 }
      config.action_mailer.delivery_method       = :letter_opener
      config.action_mailer.perform_deliveries    = true
      config.action_mailer.raise_delivery_errors = true
    """
  end
  environment env: "production" do
    """
      config.action_mailer.delivery_method       = :sparkpost
      config.action_mailer.perform_deliveries    = true
      config.action_mailer.raise_delivery_errors = false
      config.action_mailer.perform_caching       = false
      config.action_mailer.asset_host            = ENV.fetch('DEFAULT_URL')
      config.action_mailer.default_url_options   = { host: ENV.fetch('DEFAULT_URL') }
    """
  end

  # config/initializers
  initializer "ahoy.rb", <<-AHOY
    class Ahoy::Store < Ahoy::DatabaseStore
    end

    # set to true for JavaScript tracking
    Ahoy.api = false

    # better user agent parsing
    Ahoy.user_agent_parser = :device_detector

    # better bot detection
    Ahoy.bot_detection_version = 2
  AHOY

  copy_file "config/initializers/devise.rb"
  copy_file "config/initializers/friendly_id.rb"

  initializer "kaminari.rb", <<-KAMINARI
    # frozen_string_literal: true
    Kaminari.configure do |config|
      # config.default_per_page = 25
      # config.max_per_page = nil
      # config.window = 4
      # config.outer_window = 0
      # config.left = 0
      # config.right = 0
      # config.page_method_name = :page
      # config.param_name = :page
      # config.params_on_first_page = false
    end
  KAMINARI

  copy_file "config/initializers/meta_tags.rb"
  copy_file "config/initializers/simple_form.rb"

  initializer "sparkpost_rails.rb", <<-SPARKPOST
    SparkPostRails.configure do |c|
      c.api_key           = ENV['SPARKPOST_KEY']
      c.html_content_only = true
    end
  SPARKPOST

  # config/locales
  copy_file "config/locales/devise.en.yml"
  copy_file "config/locales/simple_form.en.yml"
  file "config/locals/loaf.en.yml", <<-LOAF
    en:
    loaf:
      errors:
        invalid_options: "Invalid option :%{invalid}. Valid options are: %{valid}, make sure these are the ones you are using."
      breadcrumbs:
        home: 'Home'
  LOAF

  # db/
  copy_file "db/seeds.rb", force: true
  [
    "db/migrate/20190720175000_create_settings.rb",
    "db/migrate/20190720152159_devise_create_users.rb",
    "db/migrate/20190720191740_add_name_and_admin_permission_to_users.rb",
    "db/migrate/20190720144752_create_friendly_id_slugs.rb",
    "db/migrate/20190720182124_create_ahoy_visits_and_events.rb",
    "db/migrate/20190720161737_create_versions.rb",
    "db/migrate/20190720190557_create_active_storage_tables.active_storage.rb"
  ].each do |filename|
    copy_file filename
  end

  # lib/
  # investigate lib/templates/haml/scaffold, does this get used?

  # copy_file spec/*

  # set up the database
  rails_command "db:migrate"
  rails_command "db:setup"
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
    database: 'postgresql',
    skip_gemfile: false,
    skip_bundle: false,
    skip_git: false,
    skip_test: true,
    edge: false
  }

  valid_options.each do |key, expected|
    next unless options.key?(key)
    actual = options[key]
    unless actual == expected
      fail Rails::Generators::Error, red("Unsupported option to rails new: #{key}=#{actual}")
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
