require 'spec_helper'

describe IshManager::MarkersController do
  render_views
  routes { IshManager::Engine.routes }
  include Devise::Test::ControllerHelpers

  before :each do
    do_setup
  end

  it '#new' do
    get :new, params: { map_id: @map.id }
    response.should be_success
    assigns(:user_profiles_list).should_not eql nil
  end

end
