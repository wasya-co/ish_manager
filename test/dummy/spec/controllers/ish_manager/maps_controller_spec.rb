require 'spec_helper'

describe IshManager::MapsController do
  render_views
  routes { IshManager::Engine.routes }
  include Devise::Test::ControllerHelpers

  before :each do
    ::Gameui::Map.destroy_all
    @map = FactoryGirl.create :map
    setup_users
  end

  it '#map_editor' do
    get :map_editor, params: { id: @map.id }
    response.should be_success
  end

end
