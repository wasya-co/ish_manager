require 'spec_helper'

describe IshManager::GalleriesController, :type => :controller do
  # render_views # doesn't work
  routes { IshManager::Engine.routes }

  before :each do
    User.all.destroy
    @user = FactoryGirl.create :user
    sign_in @user, :scope => :user

    allow(controller).to receive(:current_user).and_return(UserStub.new({ :manager => true }))
  end

  describe 'new' do
    it 'renders' do
      get :new
      response.should be_success
    end
  end

end
