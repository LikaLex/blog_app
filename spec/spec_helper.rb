require 'rack/test'
require 'rspec'
require 'database_cleaner/active_record'
require_relative 'support/json'

ENV['RACK_ENV'] = 'test'
require './boot'

require File.expand_path '../../blog_app.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods
  def app() BlogApp end
end

# For RSpec 2.x and 3.x
RSpec.configure { |c| c.include RSpecMixin }
RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

end


