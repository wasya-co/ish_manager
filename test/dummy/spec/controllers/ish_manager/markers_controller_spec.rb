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
      slug = 'this-slug'

      @map = create(:map, slug: slug)

      @admin_profile.update_attributes({ role_name: :admin })
      sign_in @user, scope: :user

      response = post :create, params: { map_id: map.id, gameui_marker: {
        name: slug,
        item_type: Gameui::Marker::ITEM_TYPE_MAP,
        destination_id: @map.id
      } }

      result = Gameui::Marker.find_by name: slug
      result.creator_profile_id.should eql @admin_profile.id
    end
  end

  it '#new' do
    get :new, params: { map_id: map.id }
    response.code.should eql '200'
    assigns(:user_profiles_list).should_not eql nil
  end

  describe '#update' do
    before do
      @map = create(:map)
      @map_2 = create(:map)
      @marker = create(:marker, creator_profile: @admin_profile, map: @map )
    end

    it 'works' do
      post :update, params: { id: @marker.id, gameui_marker: { description: 'another' } }
      @marker.reload.description.should eql 'another'
    end

    it 'touches the previous, and next, map' do
      t_1 = @map.updated_at
      t_2 = @map_2.updated_at

      post :update, params: { id: @marker.id, gameui_marker: { map_id: @map_2.id } }
      expect( @map.reload.updated_at).to be > t_1
      expect( @map_2.reload.updated_at).to be > t_2
    end
  end

end
