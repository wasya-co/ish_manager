require 'spec_helper'
require 'rack/test'

describe IshManager::ReportsController, :type => :controller do
  render_views
  routes { IshManager::Engine.routes }

  before :each do
    setup_users

    Report.all.destroy
    @report = create :report, :name => 'xx-test-report-xx'
  end

  describe 'update' do
    it 'touches on photo update' do
      n = @report.updated_at
      file = Rack::Test::UploadedFile.new(Rails.root.join 'data', 'image.jpg' )
      post :update, :params => { :id => @report.id, :photo => file, :report => { :name => @report.name } }
      @report.reload
      @report.updated_at.should_not eql n
    end
  end

end
