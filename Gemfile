source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.2', '>= 6.0.2.1'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.4'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# ------------------------------------------------------------------
# Need to Add First
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'
gem 'pg'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem "sassc", "< 2.2.0"

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

# Devise (needed for Active Admin)
gem 'devise'

# CanCan 
gem 'cancancan'

gem 'draper'
gem "pundit"

# bundle exec rake doc:rails generates the API under doc/api.
#gem 'sdoc', group: :doc

# ------------------------------------------------------------------


gem 'grape'
gem 'rubyXL'
gem 'carrierwave'   
#gem 'bootstrap-sass'  
# Show all api grape routes
gem 'grape_on_rails_routes'

gem 'rufus-scheduler' # Scheduler Task

gem 'fcm'

gem 'rack-cors', :require => 'rack/cors' # For middleware communication

#faker
gem 'faker'
gem 'rubocop-faker'

gem 'rake'

# Active Admin
gem 'activeadmin'
gem 'select2-rails'
gem 'activeadmin-select2', github: 'mfairburn/activeadmin-select2'

# Foundation
gem 'foundation-rails'
gem 'autoprefixer-rails'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Production
#gem 'capistrano'
#gem 'capistrano-rails'
#gem 'capistrano-passenger'
#gem 'capistrano-rbenv'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem "capistrano"
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-rvm'
  gem 'capistrano-passenger'
  gem 'capistrano-rails-collection'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
