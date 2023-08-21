require 'spec_helper'

describe IshManager::EmailTemplatesController, :type => :controller do
  render_views
  routes { IshManager::Engine.routes }

  before :each do
    setup_users
    @tmpl = create :email_template
  end

  # alphabetized

  describe "#iframe_src" do
    it 'succeeds' do
      get :iframe_src, params: { id: @tmpl.id }
      response.code.should eql '200'
    end
  end

  describe "#show" do
    it 'does' do
      get :show, :params => { :id => @tmpl.id }
      response.code.should eql '200'
    end
  end

end
