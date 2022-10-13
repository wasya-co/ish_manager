require 'spec_helper'

describe IshManager::NewsitemsController, :type => :controller do
  render_views
  routes { IshManager::Engine.routes }
  include Devise::Test::ControllerHelpers


  before :each do
    do_setup
  end

  describe 'destroy' do
    skip 'touches tag on destroy' do
      ;
    end
  end

end
