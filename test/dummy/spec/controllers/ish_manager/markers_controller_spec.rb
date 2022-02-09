require 'spec_helper'

describe IshManager::MarkersController do
  render_views
  routes { IshManager::Engine.routes }
  include Devise::Test::ControllerHelpers

  let(:map) { create(:map) }

  before :each do
    setup_users
  end

  describe '#create' do
    it 'sets creator_profile' do
      slug = 'this-here-slug'
      post :create, params: { map_id: map.id, gameui_marker: {
        name: slug, item_type: Gameui::Marker::ITEM_TYPE_MAP, slug: slug
      } }
      result = Gameui::Marker.find_by slug: slug
      result.creator_profile_id.should eql @user.profile.id
    end
  end

  it '#new' do
    get :new, params: { map_id: map.id }
    response.should be_success
    assigns(:user_profiles_list).should_not eql nil
  end

  describe '#update' do
    it 'touches the previous, and next, map' do
      raise 'not implemented'
    end
  end

end
