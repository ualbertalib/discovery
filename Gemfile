source 'http://rubygems.org'

# Core Rails stuff
gem "activerecord-session_store"
gem 'rails', '4.2.10'

# Database stuff
gem 'mysql2', '~> 0.4.10'

# Assets (CSS/JS) stuff
gem 'coffee-rails', '~> 4.2.2'
gem 'jbuilder', '~> 2.0'
gem 'jquery-rails'
gem 'sass-rails', '~> 5.0.1'
gem 'therubyracer', platforms: :ruby
gem 'turbolinks', '5.2.0'
gem 'uglifier', '>= 1.3.0'

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring', group: :development

# blacklight stuff
gem "blacklight", "5.15.0"
gem "blacklight-marc", "~> 5.10.0"
gem "blacklight_advanced_search"
gem 'blacklight_google_analytics'
gem "blacklight_range_limit"
gem "jettywrapper", "~> 2.0.3"

# Authentication
gem "devise"
gem "devise-guests"

# Misc Utilities
gem "addressable", "2.5.2"
gem 'friendly_id'
gem "htmlentities"
gem 'nokogiri', '~> 1.8.5'
gem "om"
gem 'paperclip', '~> 6.1.0'

# Content Management System
gem 'comfortable_mexican_sofa', '1.12.9'

# Performance monitoring
gem 'rollbar'

group :test, :development do
  gem 'sdoc', require: false

  gem 'capybara'
  gem 'selenium-webdriver'

  gem 'factory_bot'

  gem "rspec"
  gem 'rspec-rails'
  gem 'rspec-solr'

  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-rails'

  gem 'rubocop', '~> 0.56.0', require: false

  gem 'scss_lint', '>= 0.56.0', require: false

  gem 'simplecov', require: false
end

group :development do
  gem 'better_errors', '>= 2.3.0'
  gem 'binding_of_caller'

  gem 'letter_opener'

  gem 'brakeman'
  gem 'listen', '~> 3.0'
end

group :test do
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end
