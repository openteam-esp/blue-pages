require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'

  require File.expand_path("../../config/environment", __FILE__)

  require 'rspec/rails'
  require 'rspec/autorun'

  require 'cancan/matchers'
  require 'shoulda-matchers'
  require 'sunspot_matchers'

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.include AttributeNormalizer::RSpecMatcher
    config.include SunspotMatchers

    config.mock_with :rspec

    config.use_transactional_fixtures = true

    config.before(:all) do
      Dir[Rails.root.join("spec/fabricators/*.rb")].each {|f| require f}
      Dir[Rails.root.join("spec/support/matchers/*.rb")].each {|f| require f}
      Sunspot.session = SunspotMatchers::SunspotSessionSpy.new(Sunspot.session)
    end
  end
end

Spork.each_run do
end
