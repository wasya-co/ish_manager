require 'spec_helper'

describe IshManager::NewsitemsController, :type => :controller do
  render_views
  routes { IshManager::Engine.routes }
  include Devise::Test::ControllerHelpers


  before :each do
    do_setup

    [ @tag ].each do |res|
      @newsitem = create :newsitem, :report_id => 'abba-1'
      res.newsitems << @newsitem
      res.updated_at = '2020-01-01'
      res.save
    end
  end

  describe 'destroy' do
    it 'touches tag on destroy' do
      [ @tag ].each do |res|
        res.newsitems.length.should eql 1
        timestamp = res.updated_at
        delete :destroy, params: { id: res.newsitems.first.id }

        res.reload
        res.updated_at.should_not eql timestamp
      end
    end
  end

end
