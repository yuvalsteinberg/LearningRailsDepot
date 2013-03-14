# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  #config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.use_transactional_examples = true

end

###############################
# Transactions cleanup

require 'database_cleaner'

DatabaseCleaner.strategy = :transaction

RSpec.configure do |config|

  def transaction_cleanup(value=nil)
    (example || self.class).metadata[:transaction_cleanup]
  end

  def model
    described_class()
  end

  def self.model
    described_class()
  end

  def database_cleaner
    DatabaseCleaner[:active_record, {:connection => model}]
  end

  config.before :each do
    if transaction_cleanup == :before_each
      database_cleaner().start
    end
  end

  config.after :each do
    if transaction_cleanup == :before_each
      database_cleaner().clean
    end
  end

  config.before :all do
    if transaction_cleanup == :before_all
      database_cleaner().start
    end
  end

  config.after :all do
    if transaction_cleanup == :before_all
      database_cleaner().clean
    end
  end

  config.before :suite do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end

end

###############################



###############################
# TODO move to controller spec

def stub_rbac_raise_exception
  expected_exception = ::RBAC::NotAuthorized.new("x", "y", "z")
  controller.stub!(:restrict_to_any!).and_raise(expected_exception)
end

def stub_rbac_allow
  controller.stub!(:restrict_to!).and_return(true)
  controller.stub!(:restrict_to_any!).and_return(true)
  controller.stub!(:allow_to?).and_return(true)
  controller.stub!(:allow_to_any?).and_return(true)
end

def stub_login_ok
  controller.stub!(:authorize_filter).and_return(true)
end

def assert_json_ok_with_data(expected_data)
  response.body.should == { :retcode => 0, :data => expected_data }.to_json
end

def assert_json_error_with_message(expected_error_message)
  response.body.should == { :retcode => 1, :alert => { :type => "error", :heading => expected_error_message } }.to_json
end

###############################

def normalize_yaml(yaml)
  if yaml.is_a? Array
    yaml = yaml.collect { |sub_yaml| normalize_yaml(sub_yaml) }
    yaml.sort_by &:to_s
  elsif yaml.is_a? Hash
    yaml.symbolize_keys!
    NI::Utils::Hash.map_value(yaml) { |value| normalize_yaml(value) }
  else # mainly integers, symbols and string
    yaml.to_s
  end
end

