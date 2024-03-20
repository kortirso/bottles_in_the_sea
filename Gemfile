# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rack', '~> 3.0'
gem 'rack-session', '~> 2.0'
gem 'rackup', '~> 2.1'
gem 'rails', '~> 7.1'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.4'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 6.0'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# css
gem 'sprockets-rails'

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem 'bcrypt', '~> 3.1'

# A ruby implementation of the RFC 7519 OAuth JSON Web Token (JWT) standard
gem 'jwt', '~> 2.5'

# dry-rb system
gem 'dry-auto_inject', '~> 1.0'
gem 'dry-container', '~> 0.11.0'
gem 'dry-validation', '~> 1.10'

# Catch unsafe migrations in development
gem 'strong_migrations', '~> 1.4'

# api serializer
gem 'jsonapi-serializer', '2.2.0'

# active jobs adapter
gem 'que', '~> 2.3'

# Pretty print
gem 'awesome_print'

# running application
gem 'foreman'

# email tracking system
gem 'emailbutler'
gem 'pagy', '> 6.0'

# A performance dashboard for Postgres
gem 'pghero'

# achievements system
gem 'kudos'

# translating
gem 'i18n-tasks', '~> 1.0.13'

group :development, :test do
  gem 'bullet', git: 'https://github.com/flyerhzm/bullet', branch: 'main'
  gem 'rubocop', '~> 1.35', require: false
  gem 'rubocop-performance', '~> 1.14', require: false
  gem 'rubocop-rails', '~> 2.15', require: false
  gem 'rubocop-rspec', '~> 2.12', require: false
end

group :development do
  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem 'rack-mini-profiler', '>= 2.3.3'
end

group :test do
  gem 'database_cleaner', '~> 2.0'
  gem 'factory_bot_rails', '~> 6.4'
  gem 'json_spec', '1.1.5'
  gem 'rails-controller-testing', '1.0.5'
  gem 'rspec-rails', '~> 6.0'
  gem 'shoulda-matchers', '~> 6.0'
  gem 'simplecov', require: false
end
