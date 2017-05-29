require 'spec_helper'

describe IshManager::PhotosController, :type => :controller do
  routes { IshManager::Engine.routes }
  before :each do
    Gallery.unscoped.each do |g|
      g.destroy
    end
    # @gallery = FactoryGirl.create :gallery
    @photo = FactoryGirl.create :photo, :gallery => @gallery
  end

  it '#destroy' do
    @temp_user = controller.current_user
    controller.current_user = User.new :email => 'test@gmail.com'
    n = Photo.count
    expect {
      delete :destroy, :params => { :id => @photo.id }
    }.to raise_exception CanCan::AccessDenied
    Photo.count.should eql n
    controller.current_user = @temp_user
    delete :destroy, :params => { :id => @photo.id }
    Photo.count.should eql( n - 1)
  end

end
