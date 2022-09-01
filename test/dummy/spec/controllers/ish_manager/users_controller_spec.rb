require 'spec_helper'

describe IshManager::UsersController do
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

end
