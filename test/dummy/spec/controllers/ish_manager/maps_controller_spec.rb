require 'spec_helper'

describe IshManager::MapsController do
  render_views
  routes { IshManager::Engine.routes }
  include Devise::Test::ControllerHelpers

  before :each do
    do_setup
  end

  describe '#import' do
    before do
      Map.all.destroy_all
      Marker.all.destroy_all
      @map = create :map, _id: '<map-id>', slug: 'import-slug-0'
      @marker = create :marker, map: @map, _id: '<marker-id>', slug: 'import-slug-0'
    end

    it 'deletes existing' do
      input_file = Rack::Test::UploadedFile.new(Rails.root.join 'data', 'map_import_1.json' )
      post :import, params: { delete_existing: '1', input: input_file }
      # puts! session[:flash], 'Flash'
      @map.reload.slug.should eql 'import-slug-1'
      @marker.reload.slug.should eql 'import-slug-1'
    end

    it 'does not delete existing' do
      input_file = Rack::Test::UploadedFile.new(Rails.root.join 'data', 'map_import_1.json' )
      post :import, params: { input: input_file }
      # puts! session[:flash], 'Flash'
      @map.reload.slug.should eql 'import-slug-0'
      @marker.reload.slug.should eql 'import-slug-0'
    end
  end

  it '#map_editor' do
    get :map_editor, params: { id: @map.id }
    puts! response.body if !response.successful?
    response.should be_successful
    assigns(:map).should_not eql nil
  end

  describe '#show' do
    it 'shows nonpublic markers' do
      @marker = create :marker, { map: @map, is_public: false }
      @marker.image = create :image_asset

      get :show, params: { id: @map.id }
      assigns(:markers).to_a.should eql [@marker]
    end
  end

end
