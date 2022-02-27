require 'spec_helper'

describe IshManager::ApplicationController, :type => :controller do
  routes { IshManager::Engine.routes }
  render_views

  it '#home - header for guy' do
    @guy = create( :user, :email => 'guy@gmail.com' )
    sign_in @guy, scope: :user

    get :home

    response.should be_successful
    response.should render_template( :partial => '_main_header_guy' )
  end

  it '#home - header for admin' do
    @manager = create(:user, email: 'manager@gmail.com')
    sign_in @manager, scope: :user

    get :home

    response.should be_successful
    response.should render_template( :partial => '_main_header_manager' )
  end
end
