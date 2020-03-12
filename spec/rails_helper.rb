# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require_relative './spec_helper'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

Capybara.default_driver = if ENV['CAPYBARA_NO_HEADLESS']
                            :selenium_chrome
                          else
                            :selenium_chrome_headless
                          end

# Capbybara 3 does no longer match DOM Elements with text spanning over
# multiple lines. This configuration re-enables this behavior.
Capybara.default_normalize_ws = true

# When running your tests Capybara lazily boots the Rails app on a random port
# and, because this host/port are unknown to Rails, links generated in serializers (i.e. 'more' facets)
# will point to the wrong URL and following them within your test app and Capybara will fail.
Rails.application.routes.default_url_options[:host] = Capybara.current_session.server.host
Rails.application.routes.default_url_options[:port] = Capybara.current_session.server.port

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock # or :fakeweb

  # Only want VCR to intercept requests to external URLs.
  config.ignore_localhost = true

  # ignore travis trying to get webdrivers
  driver_hosts = Webdrivers::Common.subclasses.map { |driver| URI(driver.base_url).host }
  config.ignore_hosts(*driver_hosts)
end

# smoke test the ingest task and setup some seed data for testing
require 'rake'
Rails.application.load_tasks
Rake::Task['delete'].invoke
%w[database_test_set sfx_test_set kule_test symphony_test_set].each do |test_set|
  # work around tasks already_invoked flag being set
  Rake::Task['ingest'].reenable
  Rake::Task['solr:marc:index'].reenable
  Rake::Task['solr:marc:index:work'].reenable

  Rake::Task['ingest'].invoke(test_set)
end

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #

  config.include Devise::Test::ControllerHelpers, type: :controller

  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
