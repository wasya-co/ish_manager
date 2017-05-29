
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../test/dummy/config/environment.rb", __FILE__)
require 'rspec/rails'

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  config.include Devise::TestHelpers, :type => :helper
  config.include Devise::TestHelpers, :type => :controller

end

# this is bad... dummy app should have devise installed, and class User
IshManager::ApplicationController.class_eval do
  attr_accessor :test_current_user
  def current_user
    @test_current_user ||= ::User.new :email => 'piousbox@gmail.com'
    @test_current_user.profile ||= ::IshModels::UserProfile.new
    return @test_current_user
  end
  def current_user= user
    @test_current_user = user
    return @test_current_user
  end
end

require_relative './factories'

def puts! a, b=''
  puts "+++ +++ #{b}"
  puts a.inspect
end
