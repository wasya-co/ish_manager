require 'spec_helper'

describe IshManager::ApplicationController, :type => :controller do
  routes { IshManager::Engine.routes }
  render_views
  before :each do
    setup_users
  end

  it '#home - header for guy' do
    sign_in @guy, scope: :user

    get :home

    response.should be_success
    response.should render_template( :partial => '_main_header_guy' )
  end

  it '#home - header for admin' do
    sign_in @manager, scope: :user

    get :home

    response.should be_success
    response.should render_template( :partial => '_main_header_manager' )
  end
end
