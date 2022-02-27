require 'spec_helper'

describe IshManager::SitesController, :type => :controller do
  render_views
  routes { IshManager::Engine.routes }
  include Devise::Test::ControllerHelpers

  before :each do
    setup_users

    Site.all.destroy
    @site = create :site

    City.all.destroy
    @city = create :city
  end

  describe 'new' do
    it 'renders' do
      sign_in @admin, :scope => :user
      get :new
      response.should be_successful
    end
  end

  describe 'create' do
    it 'succeeds' do
      sign_in @admin, :scope => :user
      n = Site.all.count

      post :create, params: { site: { domain: 'test-domain' } }

      Site.all.count.should eql(n + 1)
    end
  end

  describe 'edit' do
    it 'manager - restricted' do
      sign_in @manager, :scope => :user
      get :edit, :params => { :id => @site.id }
      response.should be_redirect
    end

    it 'admin - success' do
      sign_in @admin, scope: :user
      get :edit, params: { id: @site.id }
      response.should be_successful
    end
  end

end
