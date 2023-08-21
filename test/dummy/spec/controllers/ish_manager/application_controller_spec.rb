require 'spec_helper'

describe IshManager::ApplicationController, :type => :controller do
  routes { IshManager::Engine.routes }
  render_views

  describe 'guy role' do
    before :each do
      User.all.destroy_all
      Ish::UserProfile.all.destroy_all
      @guy = create( :user, :email => 'guy@gmail.com' )
      @guy_profile = create( :profile, email: @guy.email, role_name: 'guy' )
      sign_in @guy, scope: :user
    end

    it '#home - header for guy' do
      get :home

      response.should be_successful
      response.should render_template( :partial => '_main_header_guy' )
    end
  end

  describe 'manager role' do
    before :each do
      User.all.destroy_all
      Ish::UserProfile.all.destroy_all
      @manager = create(:user, email: 'manager@gmail.com')
      @manager_profile = create(:profile, email: @manager.email, role_name: 'admin' )
      sign_in @manager, scope: :user
    end

    it '#home - header for admin' do
      get :home

      response.should be_successful
      response.should render_template( :partial => '_main_header_admin' )
    end

    it 'sets @page_title' do
      get :home

      assigns(:page_title).should eql('application home ')
    end
  end

end
