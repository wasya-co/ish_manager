require 'spec_helper'

describe IshManager::VideosController, :type => :controller do
  render_views
  routes { IshManager::Engine.routes }

  before do
    setup_users
    @video = create :video
  end

  it '#create' do
    name = 'a-uniq-name'
    Video.where( name: name ).length.should eql 0
    v = build :video, name: name
    v.youtube_id.should eql nil

    post :create, params: { video: v.attributes }
    Video.where( name: name ).length.should eql 1
  end

  it '#destroy, and the deleted video is accessible' do
    v = create :video
    delete :destroy, params: { id: v.id }
    vv = Video.where( id: v.id ).first
    vv.should eql nil

    get :show, params: { id: v.id }
    response.should be_successful
    assigns(:video).name.should eql 'some-name'
  end

  describe '#edit' do
    it 'sets variables' do
      get :edit, params: { id: @video.id }
      response.should be_successful
      assigns(:user_profiles_list).should_not eql nil
    end
  end

end
