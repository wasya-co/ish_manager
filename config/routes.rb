
IshManager::Engine.routes.draw do

  root :to => 'application#home'

  get 'categories', to: 'categories#index'

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

  namespace :iro do
    get 'watches', to: 'iro_watches#index'
  end

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

  resources :office_actions

  resources :email_campaigns
  resources :email_campaign_leads, as: :campaign_leads

  resources :email_messages

  get  'email_contexts/iframe_src/:id',          to: 'email_contexts#iframe_src', as: :email_context_iframe
  get  'email_contexts/new_with/:template_slug', to: 'email_contexts#new'
  post 'email_contexts/send/:id',                to: 'email_contexts#do_send',    as: :email_context_send
  get  'email_contexts',                         to: 'email_contexts#index',      as: :email_contexts,         defaults: { notsent: false }
  get  'email_contexts/notsent',                 to: 'email_contexts#index',      as: :notsent_email_contexts, defaults: { notsent: true }
  resources :email_contexts

  get    'email_templates/iframe_src/:id', to: 'email_templates#iframe_src', as: :email_template_iframe
  get    'email_templates/show/:id',       to: 'email_templates#show',       as: :email_template
  patch  'email_templates/show/:id',       to: 'email_templates#update'
  delete 'email_templates/show/:id',       to: 'email_templates#destroy'
  resources :email_templates

  resources :email_unsubscribes

  get 'leads',      :to => 'leads#index'
  post 'leads/bulkop', to: 'leads#bulkop'
  post 'leads/import', to: 'leads#import', as: :leads_import
  resources :leads

  resources :leadsets


  resources :meetings

  resources :newsitems

  resources :photos
  resources :payments

  resources :reports

  resources :user_profiles do
    resources :newsitems
  end
  resources :user_profiles, :as => :profiles do
    # resources :newsitems
  end

  resources :videos

end
