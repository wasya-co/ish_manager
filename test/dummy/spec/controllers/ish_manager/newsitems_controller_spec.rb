require 'spec_helper'

describe IshManager::NewsitemsController, :type => :controller do
  render_views
  routes { IshManager::Engine.routes }
  include Devise::Test::ControllerHelpers

  before :each do
    do_setup ## Users, Reports, Maps, Purchases
    @report = create(:report)
    @map = create(:map)
    @newsitem = create(:newsitem, map_id: @map.id, report_id: @report_id)
  end

  describe 'edit' do
    it 'renders' do
      get :edit, params: { id: @newsitem.id }
      response.should have_http_status(:success)
    end
  end

  describe 'update' do
    it 'does' do
      post :update, params: { id: @newsitem.id, newsitem: { name: 'another name' } }
      puts! response.body if response.code != '302'
      response.should be_redirect
    end
  end

end
