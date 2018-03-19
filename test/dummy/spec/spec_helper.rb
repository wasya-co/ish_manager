
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
    @profile = OpenStruct.new :role_name => :guy,
                              :friends => []
    if args[:manager]
      @profile[:manager?] = true
      @profile[:sudoer?] = true
      @profile[:role_name] = :admin
    end
    if args[:sudoer]
      @profile[:sudoer?] = true
    end
  end

  def profile= profile
    @profile = profile
  end

  def profile
    return @profile
  end

  def email
    return 'some@email.com'
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
  @user   = FactoryGirl.create :user, :email => 'user@gmail.com'
  @user_1 = FactoryGirl.create :user, :email => 'user-1@gmail.com'
  @user_2 = FactoryGirl.create :user, :email => 'user-2@gmail.com'
  sign_in @user, :scope => :user
  allow(controller).to receive(:current_user).and_return(UserStub.new(:manager => true ))
end

def setup_profiles
  emails = %w( one@gmail.com two@gmail.com three@gmail.com )
  @profiles = {}
  IshModels::UserProfile.all.destroy
  emails.each_with_index do |email, index|
    u = FactoryGirl.create :user, :email => email
    p = FactoryGirl.create :user_profile, :email => email, :user => u, :name => 'some-name'
    @profiles[index] = p
  end
end

def setup_reports
  Report.all.destroy
  @report = FactoryGirl.create :report
end

def setup_tags
  Report.all.destroy
  @report = FactoryGirl.create( :report, :name => rand(1000), :name_seo => rand(1000) )

  Tag.all.destroy
  @tag = FactoryGirl.create :tag
  @tag.reports << @report
  @tag.save
end
