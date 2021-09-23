require 'spec_helper'

describe IshManager::NewsitemsController, :type => :controller do
  render_views
  routes { IshManager::Engine.routes }
  include Devise::Test::ControllerHelpers


  before :each do
    @site = FactoryGirl.create :site
    @newsitem = FactoryGirl.create :newsitem, :report_id => 'abba-1'
    @site.newsitems << @newsitem
    @site.updated_at = '2020-01-01'
    @site.save
    setup_users
  end

  describe 'destroy' do
    it 'touches sites on destroy' do
      @site.newsitems.length.should eql 1
      timestamp = @site.updated_at
      delete :destroy, params: { site_id: @site.id, id: @site.newsitems.first.id }

      @site.reload
      @site.updated_at.should_not eql timestamp
    end
  end

end
