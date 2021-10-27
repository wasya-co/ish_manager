require 'spec_helper'

describe IshManager::SitesController, :type => :controller do
  render_views
  routes { IshManager::Engine.routes }
  include Devise::Test::ControllerHelpers

  before :each do
    Site.all.destroy
    @site = FactoryGirl.create :site

    City.all.destroy
    @city = FactoryGirl.create :city

    IshModels::UserProfile.all.destroy
    @p1 = FactoryGirl.create :user_profile, role_name: :manager, email: 'p_1@gmail.com'
    @p2 = FactoryGirl.create :user_profile, role_name: :admin, email: 'p_2@gmail.com'

    User.all.destroy
    @manager_user = FactoryGirl.create :user, profile: @p1, email: 'p_1@gmail.com'
    @admin_user = FactoryGirl.create :user, profile: @p2, email: 'p_2@gmail.com'

    allow(controller).to receive(:current_user).and_return(UserStub.new({ admin: true, manager: true, }))
  end

  describe 'new' do
    it 'renders' do
      sign_in @admin_user, :scope => :user
      get :new
      response.should be_success
    end
  end

  describe 'create' do
    it 'succeeds' do
      sign_in @admin_user, :scope => :user
      n = Site.all.count

      post :create, params: { site: { domain: 'test-domain' } }

      response.should be_redirect
      Site.all.count.should eql(n + 1)
    end
  end

  describe 'edit' do
    it 'renders' do
      sign_in @manager_user, :scope => :user
      get :edit, :params => { :id => @site.id }
      response.should be_success
    end
  end

end
