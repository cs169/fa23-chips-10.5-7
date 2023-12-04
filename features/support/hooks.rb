# frozen_string_literal: true

Before('@reset_database') do
  puts '  Resetting database...'
  system('RAILS_ENV=test bundle exec rake db:create > /dev/null 2>&1')
  system('RAILS_ENV=test bundle exec rails db:seed > /dev/null 2>&1')
end
