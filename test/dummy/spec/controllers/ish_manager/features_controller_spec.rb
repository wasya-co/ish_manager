require 'spec_helper'

describe IshManager::FeaturesController, :type => :controller do
  render_views
  routes { IshManager::Engine.routes }
  include Devise::Test::ControllerHelpers

  before :each do
    City.all.destroy
    @city = create :city

    User.all.destroy
    @user = create :user
    sign_in @user, :scope => :user
    
    allow(controller).to receive(:current_user).and_return(UserStub.new({ :manager => true }))
  end
  
  describe 'new in city' do
    it 'renders' do
      get :new, :params => { :city_id => @city.id }
      response.should be_success
    end
  end

=begin
  describe 'edit in city' do
    it 'renders' do
      get :edit, :params => { :city_id => @city.id }
      response.should be_success
    end
  end
=end

end
