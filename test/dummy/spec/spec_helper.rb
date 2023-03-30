
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'devise'

ActiveSupport::Deprecation.silenced = true

## From: https://github.com/DatabaseCleaner/database_cleaner-mongoid
DatabaseCleaner.clean

def puts! a, b=''
  puts "+++ +++ #{b}"
  puts a.inspect
end

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

def create_admin
  User.where( email: 'piousbox@gmail.com' ).first || create(:user, email: 'piousbox@gmail.com')
end

##
## Cannot be alphabetized!
##
def do_setup

  setup_users

  # R
  Report.unscoped.destroy_all
  @report = create :report

  ## M
  @map = create :map
  @map.image = Ish::ImageAsset.new({ image: File.new(File.join(Rails.root, 'data', 'image.jpg')) })
  @map.save

  # P
  ::Ish::Payment.unscoped.destroy_all
  @purchase = create :purchase, item: @report, profile: @guy_profile

end


def setup_users
  DatabaseCleaner.clean

  @admin = create :user, email: 'piousbox@gmail.com'
  @admin_profile = create(:profile, email: @admin.email, role_name: 'admin')
  sign_in @admin, scope: :user

  @guy = create(:user)
  @guy_profile = create(:profile, email: @guy.email, role_name: 'guy')
end

Paperclip.options[:log] = false
