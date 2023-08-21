require 'spec_helper'

describe IshManager::UserProfilesController, :type => :controller do
  render_views
  routes { IshManager::Engine.routes }

  before do
    do_setup
  end

  describe "#index" do
    it "renders" do
      get :index
      response.should be_successful
    end
  end

  describe '#new' do
    it 'renders' do
      get :new
      response.should be_successful
    end
  end

  describe '#edit' do
    it 'renders' do
      get :edit, :params => { :id => @admin_profile.id }
      response.should be_successful
    end
  end

  describe '#show' do
    it 'renders with premium purchase - report' do
      get :show, params: { id: @admin_profile.id }
      response.should be_successful
    end
  end

end
