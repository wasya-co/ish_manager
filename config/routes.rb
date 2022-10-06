
IshManager::Engine.routes.draw do

  root :to => 'application#home'

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

  resources :email_campaigns, as: :email_campaigns

  get 'email_contexts/iframe_src/:id', to: 'email_contexts#iframe_src', as: :email_context_iframe
  get 'email_contexts/new_with/:template_slug', to: 'email_contexts#new'
  post 'email_contexts/send/:id', to: 'email_contexts#do_send', as: :email_context_send
  get 'email_contexts', to: 'email_contexts#index', defaults: { notsent: false }, as: :email_contexts
  get 'email_contexts/notsent', to: 'email_contexts#index', defaults: { notsent: true }, as: :notsent_email_contexts
  resources :email_contexts

  get 'email_templates/iframe_src/:id', to: 'email_templates#iframe_src', as: :email_template_iframe
  get 'email_templates/show/:id', to: 'email_templates#show', as: :email_template
  delete 'email_templates/show/:id', to: 'email_templates#destroy'
  resources :email_templates
  resources :email_unsubscribes

  get 'leads',      :to => 'leads#index', :defaults => { :is_done => false }, as: :leads
  get 'leads/done', :to => 'leads#index', :defaults => { :is_done => true }, :as => :done_leads
  resources :leads

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
