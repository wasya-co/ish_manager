require 'spec_helper'

describe IshManager::MapsController do
  render_views
  routes { IshManager::Engine.routes }
  include Devise::Test::ControllerHelpers

  before :each do
    do_setup
  end

  it '#map_editor' do
    get :map_editor, params: { id: @map.id }
    response.should be_success
    assigns(:map).should_not eql nil
  end

  describe '#show' do
    it 'shows nonpublic markers' do
      @marker = FactoryGirl.create :marker, { map: @map, is_public: false }
      get :show, params: { id: @map.id }
      assigns(:markers).should eql [@marker]
    end
  end

end
