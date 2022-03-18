require 'spec_helper'

describe IshManager::CitiesController, :type => :controller do
  render_views
  routes { IshManager::Engine.routes }
  include Devise::Test::ControllerHelpers

  before do
    @admin = create(:user, role_name: 'manager')
    sign_in @admin, scope: :user
    @city = create :city
  end

  describe '#new' do
    it 'renders' do
      get :new
      response.should be_successful
    end
  end

  describe '#edit' do
    it 'renders' do
      get :edit, :params => { :id => @city.id }
      response.should be_successful
    end
  end

  it '#show' do
    get :show, params: { id: @city.id }
    puts! response.body if !response.successful?
    response.should be_successful
  end

end
