require 'spec_helper'

describe IshManager::GalleriesController, :type => :controller do
  render_views
  routes { IshManager::Engine.routes }

  before :each do
    setup_users
    Gallery.unscoped.destroy_all
    @gallery = FactoryGirl.create :gallery,
      :name => 'xx-test-gallery-xx', :user_profile => controller.current_user.profile,
      slug: 'xxSlugxx'
  end

  # alphabetized

  describe "#create" do
    it "redirects after creation" do
      post :create, params: { gallery: { name: "abba" } }
      new_gallery = Gallery.where( name: "abba" ).first
      response.should redirect_to edit_gallery_path(new_gallery.id)
    end

    it 'succeeds' do
      n_galleries = Gallery.count
      post :create, :params => { :gallery => { :name => "abba-#{rand(100)}" } }
      Gallery.count.should eql n_galleries+1
    end

    it 'fails' do
      n_galleries = Gallery.count
      post :create, params: { gallery: { is_trash: true } }

      Gallery.count.should eql n_galleries
      assigns( :cities_list ).should_not eql nil
      assigns( :tags_list ).should_not eql nil
    end
  end

  describe "#index" do

    it '#index_titles' do
      get :index, :params => { :render_type => Gallery::RENDER_TITLES }
      response.should render_template 'index_titles'
      assigns( :shared_galleries ).should eql nil
      gs = assigns( :galleries )
      gs.length.should > 0
    end

    it 'searches done galleries as well as active ones' do
      gallery_name = 'abba1233'
      g = Gallery.create({ is_done: true,
        name: gallery_name,
        user_profile_id: @profile.id })
      get :index, params: { q: gallery_name, render_type: Gallery::RENDER_THUMBS }
      assert assigns(:galleries).map(&:name).include?(gallery_name)
    end

  end

  describe '#new' do
    it 'renders' do
      get :new
      response.should be_success
      assigns( :gallery ).should_not eql nil
      assigns( :cities_list ).should_not eql nil
      assigns( :tags_list ).should_not eql nil
    end
  end

  describe '#show' do
    it 'shows trash' do
      get :show, :params => { :id => @gallery.id }
      assigns( :deleted_photos ).should_not eql nil
    end

    it 'shows visibility, visibility_off for non-public galleries' do
      get :show, :params => { :id => @gallery.id }
      response.body.should match "<i class='material-icons'>visibility</i>"
      response.body.should_not match "<i class='material-icons'>visibility_off</i>"

      @gallery.update_attributes is_public: false
      get :show, :params => { :id => @gallery.id }
      response.body.should_not match "<i class='material-icons'>visibility</i>"
      response.body.should match "<i class='material-icons'>visibility_off</i>"
    end
  end

  describe '#update' do
    it 'sends email to new shared profiles' do
      setup_profiles
      @gallery.shared_profiles = [ @profiles[0], @profiles[1] ]
      @gallery.save

      expect( ::IshManager::ApplicationMailer ).to receive( :shared_galleries ).with( [ @profiles[2] ], @gallery ).and_return(OpenStruct.new)
      post :update, :params => { :id => @gallery.id, :gallery => { :shared_profiles => [ @profiles[1].id, @profiles[2].id ] } }
    end
  end

end
