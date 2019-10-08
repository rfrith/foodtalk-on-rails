source 'https://rubygems.org'

#ruby=ruby-2.6.2
#ruby-gemset=rails5.1.7

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.7'

gem 'pg', '~> 1.1', '>= 1.1.4'
#gem 'activerecord-jdbcpostgresql-adapter', :platform => :jruby

# Use Puma as the app server
gem 'puma', '~> 3.12'

# Use SCSS for stylesheets
gem 'sassc-rails', '~> 2.1'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 4.1', '>= 4.1.20'

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2', '>= 4.2.2'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5.2'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.8'

# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.1'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1', '>= 3.1.12'


# custom gems
gem 'omniauth'
gem 'omniauth-auth0', '~> 2.1'
#gem 'omniauth-rails_csrf_protection', '~> 0.1'
gem 'bootstrap', '~> 4.3', '>= 4.3.1'
gem 'font-awesome-rails', '~> 4.7', '>= 4.7.0.4'
gem 'gibbon', '~> 3.2'
gem 'carrierwave', '~> 1.3', '>= 1.3.1'
gem 'fractional', '~> 1.2', '>= 1.2.1'
gem 'aasm', '~> 5.0', '>= 5.0.2'
gem 'faker', '~> 1.9', '>= 1.9.3'
#for memcached integration
gem 'dalli', '~> 2.7', '>= 2.7.10'
gem 'connection_pool', '~> 2.2', '>= 2.2.2'
gem 'api_cache', '~> 0.3.0'
gem 'mobility', '~> 0.8.6'


#TODO FIX ME! THIS DOESN'T WORK: gem 'rmagick', '~> 3.0'
# An error occurred while installing rmagick (3.0.0), and Bundler cannot continue.
#
# Make sure that `gem install rmagick -v '3.0.0'` succeeds before bundling.
# In Gemfile:
#
#   rmagick
gem 'rmagick', '~> 2.16.0'
#gem 'rmagick4j', require: 'RMagick'


gem 'pundit', '~> 2.0', '>= 2.0.1'
gem 'chartkick', '~> 3.0', '>= 3.0.2'
gem 'groupdate', '~> 4.1', '>= 4.1.1'
gem 'kaminari', '~> 1.1', '>= 1.1.1'
gem 'lol_dba', '~> 2.1', '>= 2.1.5'
gem 'rails-i18n', '~> 5.1', '>= 5.1.3'
gem 'sidekiq'

#TODO: decide on
#gem 'foreman', '~> 0.85.0'
#gem 'resque', '~> 2.0'
#gem 'resque-scheduler', '~> 4.3', '>= 4.3.1'

gem 'jquery-rails', '~> 4.3', '>= 4.3.3'
gem 'popper_js', '~> 1.14', '>= 1.14.5'

group :test do
  #TODO FIX ME!  THIS DOESN'T WORK: gem 'sqlite3', '~> 1.4'
  gem 'sqlite3', '~> 1.3.13'
  #gem 'activerecord-jdbcsqlite3-adapter'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 11.0', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 3.14'
  gem 'selenium-webdriver', '~> 3.141'
  gem 'rspec-rails', '~> 3.8', '>= 3.8.2'
  gem 'factory_bot_rails', '~> 5.0', '>= 5.0.1'
end

group :development do
  gem 'dotenv-rails'

  # Deploy using Capistrano & RVM
  gem 'capistrano', '~> 3.11', require: false
  gem 'capistrano-rails', '~> 1.4', require: false
  gem 'capistrano-rvm', '~> 0.1.2', require: false
  gem 'capistrano-bundler', '~> 1.5', require: false
  gem 'capistrano3-puma', '~> 3.1', '>= 3.1.1', require: false
  gem 'capistrano-maintenance', '~> 1.2', require: false

  #gem 'mina', require: false
  #gem 'mina-puma', require: false


  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '~> 3.7'
  gem 'listen', '~> 3.1', '>= 3.1.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 2.0', '>= 2.0.2'
  gem 'spring-watcher-listen', '~> 2.0', '>= 2.0.1'
  gem 'spring-commands-rspec', '~> 1.0', '>= 1.0.4'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', '~> 1.2018', '>= 1.2018.9', platforms: [:mingw, :mswin, :x64_mingw, :jruby]