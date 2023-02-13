require 'spec_helper'

describe IshManager::EmailContextsController, :type => :controller do
  render_views
  routes { IshManager::Engine.routes }

  before :each do
    setup_users
    @tmpl = create :email_template
  end

  # alphabetized

  describe "#new" do
    it 'succeeds' do
      get :new
      response.code.should eql '200'
    end
  end

  describe "#index" do
    it 'does' do
      get :index
      response.code.should eql '200'
    end
  end

end

