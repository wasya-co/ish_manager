require 'spec_helper'

describe IshManager::ApplicationController, :type => :controller do
  routes { IshManager::Engine.routes }
  render_views
  before :each do
    setup_users
    allow(controller).to receive(:current_user).and_return(UserStub.new({ :manager => true }))

    Gallery.all.destroy
    @gallery = FactoryGirl.create :gallery, :name => 'xx-test-gallery-xx'
  end

  it '#home - header for each role' do
    get :home
    response.should be_success
    response.should render_template( :partial => '_main_header_guy' )
  end
end
