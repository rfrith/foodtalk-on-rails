source 'https://rubygems.org'

#ruby=2.4.2
#ruby-gemset=foodtalk_rails514

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.5'

# Rails doesn't support Postgres 1.0 gem yet
# https://github.com/rails/rails/issues/31673
gem 'pg', '~> 0.21.0'
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


# custom gems
gem 'omniauth'
gem 'omniauth-auth0'
gem 'bootstrap', '~> 4.0.0'
gem 'font-awesome-rails'
gem 'gibbon', '~> 3.1', '>= 3.1.1'
gem 'carrierwave', '~> 1.2', '>= 1.2.1'
gem 'fractional', '~> 1.2'
gem 'aasm'
gem 'rmagick'
gem 'pundit'
gem 'chartkick', '~> 2.3', '>= 2.3.5'
gem 'groupdate'
gem 'kaminari'


#TODO: decide on
#gem 'foreman'
#gem 'resque'
#gem 'resque-scheduler'

gem 'jquery-rails'
gem 'popper_js', '~> 1.12.3'

group :test do
  gem 'sqlite3'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'rspec-rails', '~> 3.6.0'
  gem 'factory_bot_rails', '~> 4.10.0'
end

group :development do
  gem 'dotenv-rails'

  # Deploy using Capistrano & RVM
  gem 'capistrano', '~> 3.10', require: false
  gem 'capistrano-rails', '~> 1.3', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-bundler', '~> 1.3', require: false
  gem 'capistrano3-puma', require: false
  gem 'capistrano-maintenance', '~> 1.0', require: false

  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring-commands-rspec'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
