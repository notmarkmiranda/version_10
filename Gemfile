source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.4.0'

gem 'rails', '~> 5.2.0'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'devise'
gem 'bootstrap', '~>4.1.1'
gem 'jquery-rails'
gem 'pundit'

group :development, :test do
  gem 'factory_bot_rails'
  gem 'faker', :git => 'https://github.com/stympy/faker.git', :branch => 'master'
  gem 'pry'
  gem 'rspec-rails'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
end

group :test do
  gem 'capybara'
  gem 'coveralls', require: false
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~>3.1'
  gem 'simplecov', require: false
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
