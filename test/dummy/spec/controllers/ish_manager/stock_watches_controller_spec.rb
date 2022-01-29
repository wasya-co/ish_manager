require 'spec_helper'

## @TODO: this too should be moved into warbler gem
describe IshManager::StockWatchesController, :type => :controller do
  render_views
  routes { IshManager::Engine.routes }

  before :each do
    setup_users
    allow(controller).to receive(:current_user).and_return(UserStub.new({ :manager => true }))

    setup_tags
  end

  it '#index' do
    get :index
    response.should be_success

    assigns(:option_watches).should_not eql nil
    assigns(:stock_watches).should_not eql nil
    assigns(:option_watch).should_not eql nil
    assigns(:stock_watch).should_not eql nil
  end

  it '#create_stock_watch' do
    expect do
      post :create_stock_watch
    end.to change( Warbler::StockWatch.count ).by( 1 )
  end

  it '#create_option_watch' do
    expect do
      post :create_stock_watch
    end.to change( Warbler::OptionWatch.count ).by( 1 )
  end

  it '#update_stock_watch' do
    a = create(:stock_watch, price: 100 )
    post :update_stock_watch, params: { id: a.id, stock_watch: { price: 99 } }
    a.reload.price.should eql 99
  end

  it '#update_option_watch' do
    a = create(:option_watch, strike: 100 )
    post :update_option_watch, params: { id: a.id, option_watch: { strike: 99 } }
    a.reload.strike.should eql 99
  end

end
