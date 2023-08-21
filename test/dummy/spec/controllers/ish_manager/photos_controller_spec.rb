require 'spec_helper'

describe IshManager::PhotosController, :type => :controller do
  routes { IshManager::Engine.routes }

  before do
    setup_users

    Gallery.unscoped.destroy
    @gallery = create(:gallery)

    Photo.unscoped.destroy
    @photo = create :photo, :gallery => @gallery
  end

  context '#destroy' do
    it '#destroy - access denied' do
      sign_out :user
      sign_in @guy, scope: :user
      n = Photo.count

      delete :destroy, :params => { :id => @photo.id }

      session[:flash]['flashes']['alert'].should_not eql nil
      Photo.count.should eql n
    end

    it '#destroy - ok for sudoer' do
      n = Photo.count
      delete :destroy, :params => { :id => @photo.id }
      Photo.count.should eql n-1
    end
  end

end
