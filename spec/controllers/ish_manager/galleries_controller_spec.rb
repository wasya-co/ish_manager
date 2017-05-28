require 'spec_helper'

# this is bad... dummy app should have devise installed, and class User
IshManager::GalleriesController.class_eval do
  def current_user
    # yolo
  end
end

describe IshManager::GalleriesController, :type => :controller do
  render_views
  routes { IshManager::Engine.routes }
  before :each do
    ;
  end

  describe 'new' do
    it 'renders' do
      get :new
      response.should be_success
    end
  end

end
