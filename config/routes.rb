
IshManager::Engine.routes.draw do

  root :to => 'application#home'

  get 'categories', to: 'categories#index'

  patch 'galleries/:id/update_ordering', to: 'galleries#update_ordering'
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


  get 'iro_watches', to: 'iro_watches#index'
  get 'iro_purse',   to: 'iro_purses#my', as: :my_purse

  resources :iro_strategies




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

  resources :email_actions

  resources :email_campaigns
  resources :email_campaign_leads, as: :campaign_leads
  resources :email_filters

  get 'email_messages/iframe/:id',   to: 'email_messages#show_iframe',   as: :email_message_iframe
  get 'email_messages/source/:id',   to: 'email_messages#show_source',   as: :email_message_source
  get 'email_messages/stripped/:id', to: 'email_messages#show_stripped', as: :email_message_stripped
  resources :email_messages

  get 'email_conversations',                   to: 'email_conversations#index'
  get 'email_conversations/in_emailtag/:slug', to: 'email_conversations#index', as: :email_conversations_in_emailtag
  get 'email_conversations/show/:id',          to: 'email_conversations#show', as: :email_conversation

  get  'email_contexts/for_lead/:lead_id',       to: 'email_contexts#index', as: :email_contexts_for_lead
  get  'email_contexts/iframe_src/:id',          to: 'email_contexts#iframe_src', as: :email_context_iframe
  get  'email_contexts/new_with_template/:template_slug', to: 'email_contexts#new'
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

  resources :lead_leadsets

  get 'leads',      :to => 'leads#index'
  post 'leads/bulkop', to: 'leads#bulkop'
  post 'leads/import', to: 'leads#import', as: :leads_import
  resources :leads

  resources :leadsets

  resources :leadset_tags


  resources :meetings

  resources :newsitems

  resources :photos
  resources :payments

  resources :reports

  resources :scheduled_email_actions

  resources :user_profiles do
    resources :newsitems
  end
  resources :user_profiles, :as => :profiles do
    # resources :newsitems
  end

  resources :videos

end
