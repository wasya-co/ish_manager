require 'spec_helper'

describe IshManager::PhotosController, :type => :controller do
  routes { IshManager::Engine.routes }
  before :each do
    Site.unscoped.destroy
    @site = FactoryGirl.create :site

    Gallery.unscoped.destroy
    @gallery = Gallery.create :site => @site

    Photo.unscoped.destroy
    @photo = FactoryGirl.create :photo, :gallery => @gallery

    User.all.destroy
    @user = FactoryGirl.create :user
    sign_in @user, :scope => :user

    allow(controller).to receive(:current_user).and_return(UserStub.new(:manager => true ))
  end

  it '#destroy - access denied' do
    allow(controller).to receive(:current_user).and_return(UserStub.new(:manager => false ))
    n = Photo.count
    expect {
      delete :destroy, :params => { :id => @photo.id }
    }.to raise_exception CanCan::AccessDenied
    Photo.count.should eql n
  end

end
