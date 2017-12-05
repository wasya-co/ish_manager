
ENV["RAILS_ENV"] ||= 'test'
# require File.expand_path("../../test/dummy/config/environment.rb", __FILE__)
require File.expand_path("../../config/environment.rb", __FILE__)
require 'rspec/rails'
require 'devise'

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  # config.include Devise::TestHelpers, :type => :helper
  # config.include Devise::TestHelpers, :type => :controller
  config.include Devise::Test::ControllerHelpers, :type => :controller

end

class UserStub
  def initialize args = {}
    @profile = OpenStruct.new
    if args[:manager]
      @profile[:manager?] = true
      @profile[:sudoer?] = true
    end
  end

  def profile= profile
    @profile = profile
  end

  def profile
    return @profile
  end
end

# this is bad... dummy app should have devise installed, and class User
=begin
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
=end

# require_relative './factories'

def puts! a, b=''
  puts "+++ +++ #{b}"
  puts a.inspect
end

def setup_users
  User.all.destroy
  @user = FactoryGirl.create :user
  sign_in @user, :scope => :user
end

def setup_profiles
  IshModels::UserProfile.all.destroy
  @profile_1 = FactoryGirl.create :user_profile, :email => 'one@gmail.com'  
  @profile_2 = FactoryGirl.create :user_profile, :email => 'two@gmail.com'
  @profile_3 = FactoryGirl.create :user_profile, :email => 'three@gmail.com'
end

