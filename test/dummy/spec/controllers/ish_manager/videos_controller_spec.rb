require 'spec_helper'

describe IshManager::VideosController, :type => :controller do
  render_views
  routes { IshManager::Engine.routes }

  before :each do
    setup_users
  end

  it '#destroy' do
    v = FactoryGirl.create :video, is_trash: true
    delete :destroy, params: { id: v.id }
    response.should be_redirect
    vv = Video.where( id: v.id ).first
    vv.should eql nil
  end

end
