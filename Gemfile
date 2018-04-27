source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end
gem 'rgeo-activerecord'
gem 'activerecord-postgis-adapter'
gem 'pry', '~> 0.11.3'
gem 'pqueue', '~> 2.1'
gem 'hirb', '~> 0.7.3'
gem 'cancancan', '~> 2.1', '>= 2.1.3'
gem 'rolify', '~> 5.2'
gem 'omniauth-facebook', '~> 4.0'
gem 'paperclip', '~> 6.0'
gem 'underscore-rails', '~> 1.8', '>= 1.8.3'
gem 'gmaps4rails', '~> 2.1', '>= 2.1.2'
gem 'geocoder', '~> 1.4', '>= 1.4.7'
gem 'ransack', '~> 1.8', '>= 1.8.8'
gem 'bootstrap-datepicker-rails', '~> 1.8', '>= 1.8.0.1'
gem 'bootstrap-timepicker-rails', '~> 0.1.3'
gem 'will_paginate', '~> 3.1', '>= 3.1.6'
gem 'bootstrap_form', '~> 2.7'
gem 'octicons_helper', '~> 4.2'
gem 'devise', '~> 4.4', '>= 4.4.1'
gem 'benchmark-ips', '~> 2.7', '>= 2.7.2'
gem 'simple_form', '~> 3.5', '>= 3.5.1'
gem 'bootstrap', '~> 4.0.0'
gem 'sprockets-rails', '~> 3.2', '>= 3.2.1', :require => 'sprockets/railtie'
gem 'bootstrap-sass', '~> 3.3', '>= 3.3.7'
gem 'jquery-rails', '~> 4.3', '>= 4.3.1'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'fcm', '~> 0.0.2'
