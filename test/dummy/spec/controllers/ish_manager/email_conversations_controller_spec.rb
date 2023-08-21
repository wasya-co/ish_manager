require 'spec_helper'

describe IshManager::EmailConversationsController, :type => :controller do
  render_views
  routes { IshManager::Engine.routes }

  before :each do
    setup_users
    @tmpl = create :email_template
    @convo = create( :email_conversation )
  end

  # Alphabetized : )

  describe "#index" do
    it 'orders conversations by latest_at' do
      c1 = create( :email_conversation )
      c2 = create( :email_conversation )
      get :index
      convos = assigns(:email_conversations)
      convos[0][:latest_at].should > convos[1][:latest_at]
    end
  end

  describe '#show' do
    it 'renders' do
      get :show, params: { id: @convo.id }
      response.code.should eql '200'
    end
  end


end

