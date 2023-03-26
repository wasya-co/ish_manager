require 'spec_helper'

describe IshManager::EmailActionsController, :type => :controller do
  render_views
  routes { IshManager::Engine.routes }

  before :each do
    setup_users
    @tmpl = create :email_template
    @act  = create :email_action
  end

  # alphabetized

  describe '#update' do
    it 'does like #create' do
      n = Act.all.length
      post :update, params: { email_action: { slug: 'some-slug', email_template_id: @tmpl.id } }
      response.code.should eql '302'
      puts!( flash[:alert], '#update like #create`s' ) if flash[:alert]
      Act.all.length.should eql( n + 1 )
    end

    it 'does like #update' do
      n = Act.all.length
      post :update, params: { id: @act, email_action: { slug: 'diff-slug' } }
      response.code.should eql '302'
      result = Act.find @act.id
      result.slug.should eql( 'diff-slug' )
    end
  end

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

