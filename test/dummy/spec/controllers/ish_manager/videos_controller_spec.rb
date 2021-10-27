require 'spec_helper'

describe IshManager::VideosController, :type => :controller do
  render_views
  routes { IshManager::Engine.routes }

  before do
    setup_users
    @video = FactoryGirl.create :video, is_trash: true

    allow(controller).to receive(:current_user).and_return(UserStub.new({ :manager => true }))
  end

  it '#destroy' do
    v = FactoryGirl.create :video, is_trash: true
    delete :destroy, params: { id: v.id }
    response.should be_redirect
    vv = Video.where( id: v.id ).first
    vv.should eql nil
  end

  describe '#edit' do
    it 'sets variables' do
      get :edit, params: { id: @video.id }
      response.should be_success
      assigns(:user_profiles_list).should_not eql nil
    end
  end

end
