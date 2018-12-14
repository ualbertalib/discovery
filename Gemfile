source 'http://rubygems.org'

# Core Rails stuff
gem 'activerecord-session_store'
gem 'rails', '4.2.11'

# Database stuff
gem 'mysql2', '~> 0.4.10'

# Assets (CSS/JS) stuff
gem 'jquery-rails'
gem 'sass-rails', '~> 5.0.1'
gem 'turbolinks', '5.2.0'
gem 'uglifier', '>= 1.3.0'

# FIXME: Since we stuck using EOL Ruby 2.1.5, need to lock this down...
gem 'bootstrap-sass', '3.3.7'

# blacklight stuff
gem 'blacklight', '5.15.0'
gem 'blacklight-marc', '~> 5.10.0'
gem 'blacklight_advanced_search'
gem 'blacklight_google_analytics'
gem 'blacklight_range_limit'

# Authentication
gem 'devise'
gem 'devise-guests'

# Misc Utilities
gem 'bootstrap_form', '~> 2.7.0'
gem 'friendly_id'
gem 'nokogiri', '~> 1.8.5'
gem 'om'
gem 'paperclip', '~> 6.1.0'

# Content Management System
gem 'comfortable_mexican_sofa', '1.12.9'

# Performance monitoring
gem 'rollbar'

group :test, :development do
  gem 'sdoc', require: false
  # FIXME: Since we stuck using EOL Ruby 2.1.5, need to lock this down...
  gem 'rdoc', '5.1.0'

  gem 'factory_bot'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'rspec-solr'

  gem 'pry'
  gem 'pry-rails'
  # FIXME: Since we stuck using EOL Ruby 2.1.5, need to lock this down...
  gem 'pry-byebug', '3.4.3'

  gem 'rubocop', '~> 0.56.0', require: false

  gem 'scss_lint', '>= 0.56.0', require: false
end

group :development do
  gem 'better_errors', '>= 2.3.0'
  gem 'binding_of_caller'

  gem 'letter_opener'

  gem 'brakeman'
  gem 'listen', '~> 3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  gem 'simplecov', require: false

  # FIXME: Since we stuck using EOL Ruby 2.1.5, need to lock this down...
  gem 'capybara', '2.18.0'
  gem 'xpath', '2.1.0'

  gem 'selenium-webdriver'

  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end
