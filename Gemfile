# frozen_string_literal: true

source 'http://rubygems.org'

# Core Rails stuff
gem 'activerecord-session_store'
gem 'puma', '~> 3.11'
gem 'rails', '~> 4.2'

# Database stuff
gem 'mysql2', '~>0.3.20'

# Assets (CSS/JS) stuff
gem 'coffee-rails', '~> 4.1.0'
gem 'jbuilder', '~> 2.0'
gem 'jquery-rails'
gem 'sass-rails', '~> 5.0.1'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'therubyracer', platforms: :ruby
gem 'turbolinks', '2.5.3'
gem 'uglifier', '>= 1.3.0'

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring', group: :development

# blacklight stuff
gem 'blacklight', '5.15.0'
gem 'blacklight-marc', '~> 5.10.0'
gem 'blacklight_advanced_search'
gem 'blacklight_google_analytics'
gem 'blacklight_range_limit'
gem 'jettywrapper', '~> 2.0.3'

# Authentication
gem 'devise'
gem 'devise-guests'

# CMS
gem 'comfortable_mexican_sofa', '1.12.9'

# Misc Utilities
gem 'addressable', '2.3.7'
gem 'friendly_id'
gem 'htmlentities'
gem 'nokogiri', '1.8.1'
gem 'om'
gem 'paperclip', '4.3.6'

group :test, :development do
  gem 'capybara'
  gem 'factory_bot'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'rspec-solr'
  gem 'rubocop', '~> 0.51.0', require: false
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
end

group :development do
  gem 'better_errors', '>= 2.3.0'
  gem 'binding_of_caller'

  gem 'brakeman'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
end
