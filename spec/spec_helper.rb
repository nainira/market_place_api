# The `.rspec` file also contains a few flags that are not defaults but that
# users commonly want.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)

# require 'rspec/autorun'
require 'rspec/rails'
require 'shoulda/matchers'


Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }


ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)
ActiveRecord::Migration.maintain_test_schema! if defined?(ActiveRecord::Migration)
RSpec.configure do |config|
  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  # deprecation warning for stub
  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  # config.expect_with :rspec do |expectations|
  #   # This option will default to `true` in RSpec 4. It makes the `description`
  #   # and `failure_message` of custom matchers include text for helper methods
  #   # defined using `chain`, e.g.:
  #   # be_bigger_than(2).and_smaller_than(4).description
  #   #   # => "be bigger than 2 and smaller than 4"
  #   # ...rather than:
  #   #   # => "be bigger than 2"
  #   expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  # end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  config.order = :random

  config.include Request::JsonHelpers, :type => :controller
  config.include Request::HeadersHelpers, :type => :controller
  config.include Devise::TestHelpers, :type => :controller
  # config.include ControllerHelpers, :type => :controller

  config.before(:each, type: :controller) do
    include_default_accept_headers
  end

end
RspecApiDocumentation.configure do |config|
  config.format = [:json, :html]
  config.app = Rails.application
end