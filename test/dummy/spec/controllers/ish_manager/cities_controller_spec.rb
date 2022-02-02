require 'spec_helper'

describe IshManager::CitiesController, :type => :controller do
  render_views
  routes { IshManager::Engine.routes }
  include Devise::Test::ControllerHelpers

  before :each do
    City.all.destroy
    @city = create :city

    User.all.destroy
    @user = create :user
    sign_in @user, :scope => :user
  end

  describe 'new' do
    it 'renders' do
      get :new
      response.should be_success
    end
  end

  describe 'edit' do
    it 'renders' do
      get :edit, :params => { :id => @city.id }
      response.should be_success
    end
  end

  it 'show' do
    get :show, params: { id: @city.id }
    response.should be_success
  end

end
