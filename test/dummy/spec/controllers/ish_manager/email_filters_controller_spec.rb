require 'spec_helper'

describe IshManager::EmailFiltersController, :type => :controller do
  render_views
  routes { IshManager::Engine.routes }

  before :each do
    setup_users
    # @tmpl = create :email_template
    # @convo = create( :email_conversation )
  end

  # Alphabetized : )

  describe "#index" do
    it 'does' do
      get :index
      response.code.should eql '200'
    end
  end

  describe "#new" do
    it 'does' do
      get :new
      response.code.should eql '200'
    end
  end

  describe "#edit" do
    it 'does' do
      @filter = create(:email_filter)
      get :edit, params: { id: @filter.id }
      response.code.should eql '200'
    end
  end

end

