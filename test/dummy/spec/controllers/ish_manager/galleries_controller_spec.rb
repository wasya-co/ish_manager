require 'spec_helper'

describe IshManager::GalleriesController, :type => :controller do
  render_views
  routes { IshManager::Engine.routes }

  before :each do
    setup_users
    @gallery = create :gallery, user_profile: @admin_profile
  end

  # alphabetized

  describe "#create" do
    it 'succeeds' do
      n_galleries = Gallery.count
      post :create, :params => { :gallery => { :name => "abba-#{rand(100)}" } }
      Gallery.count.should eql n_galleries+1
    end
    it "redirects after creation" do
      post :create, params: { gallery: { name: "abba" } }
      new_gallery = Gallery.where( name: "abba" ).first
      response.should redirect_to edit_gallery_path(new_gallery.id)
    end
    it 'fails' do
      n_galleries = Gallery.count
      post :create, params: { gallery: { is_trash: true } }

      Gallery.count.should eql n_galleries
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

  end

  describe '#new' do
    it 'renders' do
      get :new
      response.should be_successful
      assigns( :gallery ).should_not eql nil
      assigns( :user_profiles_list ).should_not eql nil
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
    it 'All: redirects to edit, ' do
      post :update, :params => { :id => @gallery.id, :gallery => { name: 'xxNewNamexx', shared_profiles: [ "" ] } }
      response.should redirect_to edit_gallery_path(@gallery.id)
    end

    it 'sends email to new shared profiles' do
      @profiles = [ 1, 2, 3 ].map do |i|
        create(:profile)
      end
      @gallery.shared_profiles = [ @profiles[0], @profiles[1] ]
      @gallery.save

      expect( ::IshManager::ApplicationMailer ).to receive( :shared_galleries ).with( [ @profiles[2] ], @gallery ).and_return(OpenStruct.new)
      post :update, :params => { :id => @gallery.id, :gallery => { :shared_profiles => [ @profiles[1].id, @profiles[2].id ] } }
    end
  end

end
