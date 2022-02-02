require 'spec_helper'

describe IshManager::FeaturesController, :type => :controller do
  render_views
  routes { IshManager::Engine.routes }
  include Devise::Test::ControllerHelpers

  before do
    setup_users
    sign_in @admin, :scope => :user

    @city = create :city
  end

  describe 'new in city' do
    it 'renders' do
      get :new, :params => { :city_id => @city.id }
      response.should be_success
    end
  end

end
