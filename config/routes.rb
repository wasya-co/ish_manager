IshManager::Engine.routes.draw do
  root :to => 'application#home'

  resources :campaigns

  resources :cities do
    resources :features
    resources :newsitems
    resources :reports
    resources :galleries
    resources :users
    resources :videos
    resources :events
    resources :venues
    resources :tags
  end

  resources :covered_calls

  resources :email_templates
  resources :events

  resources :features
  resources :friends

  get 'galleries', :to => 'galleries#index', :defaults => { :render_type => Gallery::RENDER_THUMBS }
  get 'galleries/index_titles', :to => 'galleries#index', :defaults => { :render_type => Gallery::RENDER_TITLES }
  get 'galleries/index_thumbs', :to => 'galleries#index', :defaults => { :render_type => Gallery::RENDER_THUMBS }
  get 'galleries/shared', to: 'galleries#shared_with_me', defaults: { render_type: Gallery::RENDER_THUMBS }
  get 'galleries/shared_titles', to: 'galleries#shared_with_me', defaults: { render_type: Gallery::RENDER_TITLES
    }, as: :galleries_shared_titles
  resources :galleries do
    post 'multiadd', :to => 'photos#j_create', :as => :multiadd
  end

  resources :invoices do
    # resources :payments
  end
  resources :iron_condors

  get 'leads',      :to => 'leads#index', :defaults => { :is_done => false }
  get 'leads/done', :to => 'leads#index', :defaults => { :is_done => true }, :as => :done_leads
  resources :leads

  scope 'gameui' do
    get 'maps/:id/map-editor', to: 'maps#map_editor', as: :location_map_editor
    resources 'maps' do
      resources 'markers'
      resources 'newsitems'
    end
    get 'maps/:id', to: 'maps#edit'
  end

  resources :newsitems

  resources :orders
  get 'co_tailors',                :to => 'co_tailors#home'
  post 'co_tailors/products',      :to => 'co_tailors#create_product'
  patch 'co_tailors/products/:id', :to => 'co_tailors#update_product', :as => :co_tailors_product

  resources :photos
  resources :payments
  ## profiles, see user_profiles

  resources :reports

  resources :sites do
    resources :features
    resources :newsitems

    get 'reports', :to => 'sites#reports'
    resources :reports

    get 'galleries', :to => 'sites#galleries'

    resources :galleries
    resources :videos
    resources :tags
  end

  # resources :stock_actions
  # resources :stock_options
  resources :stock_watches

  resources :tags do
    resources :features
    resources :newsitems

    resources :reports
    resources :galleries
    resources :videos
  end

  resources :user_profiles do
    resources :newsitems
  end
  resources :user_profiles, :as => :profiles do
    resources :newsitems
  end

  resources :venues
  resources :videos

end
