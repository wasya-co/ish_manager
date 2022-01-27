
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'factory_bot'
require 'devise'

## From: https://github.com/DatabaseCleaner/database_cleaner-mongoid
# DatabaseCleaner[:mongoid].strategy = [:deletion]

RSpec.configure do |config|

  config.include FactoryBot::Syntax::Methods

  ## 20210205
  config.include Rails.application.routes.url_helpers
  config.include Warden::Test::Helpers
  Warden.test_mode!


  config.infer_spec_type_from_file_location!

  # config.include Devise::TestHelpers, :type => :helper
  # config.include Devise::TestHelpers, :type => :controller
  config.include Devise::Test::ControllerHelpers, :type => :controller

end

# @TODO: remove this, right?
class UserStub
  def initialize args = {}
    @profile = OpenStruct.new :role_name => :guy, :friends => []
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

  def id
    return 1
  end

end

def puts! a, b=''
  puts "+++ +++ #{b}"
  puts a.inspect
end

##
## Cannot be alphabetized!
##
def do_setup
  setup_users

  # C
  City.unscoped.destroy_all
  @city = FactoryBot.create :city

  # R
  Report.unscoped.destroy_all
  @report = FactoryBot.create :report

  # M
  ::Gameui::Marker.unscoped.destroy_all
  ::Gameui::Map.unscoped.destroy_all
  @map = FactoryBot.create :map
  @map.image = Ish::ImageAsset.new({ image: File.new(File.join(Rails.root, 'data', 'image.jpg')) })
  @map.save

  # P
  ::Gameui::PremiumPurchase.unscoped.destroy_all
  @purchase = FactoryBot.create :purchase, item: @report, user_profile: @profile

  # S
  Site.unscoped.destroy_all
  @site = FactoryBot.create :site

  # T
  Tag.unscoped.destroy_all
  @tag = FactoryBot.create :tag

end

def setup_profiles
  emails = %w( one@gmail.com two@gmail.com three@gmail.com )
  @profiles = {}
  Ish::UserProfile.all.destroy
  emails.each_with_index do |email, index|
    u = FactoryBot.create :user, :email => email
    p = FactoryBot.create :user_profile, :email => email, :user => u, :name => 'some-name'
    @profiles[index] = p
  end
end

def setup_reports
  Report.all.destroy
  @report = FactoryBot.create :report
end

def setup_tags
  Report.all.destroy
  @report = FactoryBot.create( :report, :name => rand(1000), :slug => rand(1000) )

  Tag.all.destroy
  @tag = FactoryBot.create :tag
  @tag.reports << @report
  @tag.save
end

def setup_users
  User.all.destroy
  Ish::UserProfile.all.destroy
  @user    = create(:user, :email => 'piousbox@gmail.com')
  @profile = FactoryBot.create :user_profile, :email => 'piousbox@gmail.com', role_name: 'manager', user: @user
  @profile.save && @profile.reload
  @user.save && @user.reload
  @user_1  = create :user, :email => 'user-1@gmail.com'
  @user_2  = create :user, :email => 'user-2@gmail.com'
  sign_in @user, :scope => :user
  # allow(controller).to receive(:current_user).and_return(UserStub.new(:manager => true ))
end

Paperclip.options[:log] = false
