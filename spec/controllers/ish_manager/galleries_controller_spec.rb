require 'spec_helper'

describe IshManager::GalleriesController, :type => :controller do
  # render_views # errors out due to current_user in view
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
