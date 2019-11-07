source 'http://rubygems.org'

# Core Rails stuff
gem 'activerecord-session_store'
gem 'rails', '4.2.11.1'

# Database stuff
gem 'mysql2', '~> 0.4.10'

# Assets (CSS/JS) stuff
gem 'bootstrap', '~> 4.3.1'
gem 'font-awesome-sass', '~> 5.11.2'
gem 'jquery-rails'
gem 'sassc-rails', '~> 2.1'
gem 'uglifier', '>= 1.3.0'

# blacklight stuff
gem 'blacklight', git: 'https://github.com/ualbertalib/blacklight'
gem 'blacklight-marc', git: 'https://github.com/ualbertalib/blacklight-marc'
gem 'blacklight_advanced_search'
gem 'blacklight_google_analytics'
gem 'blacklight_range_limit', git: 'https://github.com/ualbertalib/blacklight_range_limit'

# Authentication
gem 'devise'
gem 'devise-guests'

# Misc Utilities
gem 'addressable', '~> 2.7.0'
gem 'bootstrap_form', '~> 2.7.0'
gem 'danger', '~> 6.1'
gem 'nokogiri', '~> 1.10.5'
gem 'om'

# Performance monitoring
gem 'rollbar'

group :test, :development do
  gem 'sdoc', require: false

  gem 'factory_bot'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'rspec-solr'

  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-rails'

  gem 'rubocop', '~> 0.56.0', require: false

  gem 'scss_lint', '>= 0.56.0', require: false
end

group :development do
  gem 'better_errors', '>= 2.3.0'
  gem 'binding_of_caller'

  gem 'erb_lint', '~> 0.0.30', require: false

  gem 'letter_opener'

  gem 'brakeman'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # Debug
  gem 'debase', '0.2.4'
  gem 'ruby-debug-ide'
end

group :test do
  gem 'simplecov', require: false

  gem 'capybara'
  gem 'selenium-webdriver'

  gem 'vcr', require: false
  gem 'webmock', require: false

  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

group :uat do
  gem 'puma', '~> 4.2'
end
