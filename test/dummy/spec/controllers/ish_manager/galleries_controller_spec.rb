require 'spec_helper'

describe IshManager::GalleriesController, :type => :controller do
  # render_views # doesn't work
  routes { IshManager::Engine.routes }

  before :each do
    setup_users
    allow(controller).to receive(:current_user).and_return(UserStub.new({ :manager => true }))

    Gallery.all.destroy
    @gallery = FactoryGirl.create :gallery, :name => 'xx-test-gallery-xx'
  end

  describe 'new' do
    it 'renders' do
      get :new
      response.should be_success
      assigns( :gallery ).should_not eql nil
    end
  end

  describe 'update' do
    it 'sends email to new shared profiles' do
      setup_profiles
      @gallery.shared_profiles = [ @profile_1, @profile_2 ]
      @gallery.save

      post :update, :params => { :id => @gallery.id, :gallery => { :shared_profiles => [ @profile_2.id, @profile_3.id ] } }

      GalleriesNotifier.should_have_been_called_with( @profile_3 )
    end
  end

end
