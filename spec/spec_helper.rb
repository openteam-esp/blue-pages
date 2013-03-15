require 'rubygems'

ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)

require 'rspec/rails'
require 'rspec/autorun'

require 'cancan/matchers'
require 'shoulda-matchers'
require 'sunspot_matchers'
require 'sso-auth/spec_helper'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.include AttributeNormalizer::RSpecMatcher
  config.include SunspotMatchers
  config.include SsoAuth::SpecHelper
  config.include BluePages::SpecHelper

  config.mock_with :rspec

  config.use_transactional_fixtures = true

  config.before { BluePages::SpecHelper.stub_message_maker }
  config.before(:all) {
    ActiveRecord::IdentityMap.enabled = true
    Dir[Rails.root.join("spec/fabricators/*.rb")].each {|f| require f}
    Dir[Rails.root.join("spec/support/matchers/*.rb")].each {|f| require f}
    Sunspot.session = SunspotMatchers::SunspotSessionSpy.new(Sunspot.session)
  }
end
