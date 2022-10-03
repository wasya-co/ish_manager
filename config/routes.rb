
IshManager::Engine.routes.draw do

  post 'email_test', to: 'application#email_test', as: :email_test

  root :to => 'application#home'

  ## @deprecated: use Locations
  resources :cities do
    resources :features
    resources :newsitems
    resources :reports
    resources :galleries
    resources :videos
    resources :events
    resources :venues
    resources :tags
  end
  resources :events

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

  get 'image_assets', to: 'image_assets#index', as: :image_assets

  # resources :invoices do
  #   resources :payments
  # end
  # resources :orders

  # namespace :iron_warbler do
  #   resources :iron_condors
  #   resources :stock_watches
  #   resources :option_watches
  #   resources :covered_calls
  # end

  scope 'gameui' do
    get 'maps/:id/map-editor', to: 'maps#map_editor', as: :location_map_editor
    resources 'maps' do
      resources 'markers'
      resources 'newsitems'
    end
    post 'maps/import', to: 'maps#import', as: :import_map
    get 'maps/:id', to: 'maps#show'
    post 'maps/:id/export', to: 'maps#export', as: :export_map

    resources 'markers'
  end


  #
  # office, below
  #
  get 'leads',      :to => 'leads#index', :defaults => { :is_done => false }, as: :leads
  get 'leads/done', :to => 'leads#index', :defaults => { :is_done => true }, :as => :done_leads
  resources :leads

  resources :meetings
  resources :email_campaigns, as: :email_campaigns

  get 'email_contexts/iframe_src/:id', to: 'email_contexts#iframe_src', as: :email_context_iframe
  get 'email_contexts/new_with/:template_slug', to: 'email_contexts#new'
  post 'email_contexts/send/:id', to: 'email_contexts#do_send', as: :email_context_send
  resources :email_contexts

  get 'email_templates/iframe_src/:id', to: 'email_templates#iframe_src', as: :email_template_iframe
  get 'email_templates/show/:id', to: 'email_templates#show', as: :email_template
  delete 'email_templates/show/:id', to: 'email_templates#destroy'
  resources :email_templates

  resources :unsubscribes
  resources :sent_emails
  #
  # office, above
  #


  resources :newsitems

  resources :photos
  resources :payments

  resources :reports

  ## @deprecated: use Locations
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

  resources :tags do
    resources :features
    resources :newsitems

    resources :reports
    resources :galleries
    resources :videos
  end

  resources :users
  resources :user_profiles do
    resources :newsitems
  end
  resources :user_profiles, :as => :profiles do
    # resources :newsitems
  end

  ## @TODO: venues can only be in cities, right?
  ## @deprecated: use Locations
  resources :venues
  resources :videos

end
