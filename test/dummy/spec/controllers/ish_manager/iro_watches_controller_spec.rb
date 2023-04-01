
require 'spec_helper'

describe IshManager::IroWatchesController, :type => :controller do
  routes { IshManager::Engine.routes }

  before do
    setup_users
  end

  context '#index' do
    it 'sanity' do
      get :index
      response.code.should eql '200'
    end
  end
end

