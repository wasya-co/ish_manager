require 'spec_helper'

describe IshManager::CitiesController, :type => :controller do
  render_views
  routes { IshManager::Engine.routes }
  include Devise::Test::ControllerHelpers

  before do
    setup_users
    sign_in @admin, scope: :user
    @city = create :city
  end

  describe '#new' do
    it 'renders' do
      get :new
      response.should be_success
    end
  end

  describe '#edit' do
    it 'renders' do
      get :edit, :params => { :id => @city.id }
      response.should be_success
    end
  end

  it '#show' do
    get :show, params: { id: @city.id }
    puts! response.body if !response.success?
    response.should be_success
  end

end
