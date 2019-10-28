require_relative "./application_template_helpers.rb"

RUBY_VERSION = "~> 2.6.1".freeze
RAILS_VERSION = "~> 6.0.0".freeze
YARN_VERSION = "~> 1.19.1".freeze

assert_ruby_version(RUBY_VERSION)
assert_rails_version(RAILS_VERSION)
assert_yarn_version(YARN_VERSION)
assert_valid_options
assert_postgres
# add_template_repository_to_source_path
