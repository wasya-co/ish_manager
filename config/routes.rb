
IshManager::Engine.routes.draw do

  ##
  ## A
  ##
  root :to => 'application#home'

  get 'analytics',      to: 'analytics#index'
  get 'analytics/test', to: 'analytics#test'

  get 'application/tinymce', to: 'application#tinymce'

  resources :appliances
  resources :appliance_tmpls

  # get 'categories', to: 'categories#index'
  post '/categories/create-email-tag', to: 'categories#create_email_tag', as: :create_email_tag
  resources :categories

  resources 'events'

  patch 'galleries/:id/update_ord', to: 'galleries#update_ordering'
  get   'galleries',                to: 'galleries#index',          defaults: { render_type: Gallery::RENDER_THUMBS }
  get   'galleries/index_titles',   to: 'galleries#index',          defaults: { render_type: Gallery::RENDER_TITLES }
  get   'galleries/index_thumbs',   to: 'galleries#index',          defaults: { render_type: Gallery::RENDER_THUMBS }
  get   'galleries/shared',         to: 'galleries#shared_with_me', defaults: { render_type: Gallery::RENDER_THUMBS }
  get   'galleries/shared_titles',  to: 'galleries#shared_with_me', defaults: { render_type: Gallery::RENDER_TITLES }, as: :galleries_shared_titles
  resources :galleries do
    post 'multiadd', :to => 'photos#j_create', :as => :multiadd
  end

  get 'image_assets', to: 'image_assets#index', as: :image_assets

  post 'invoices/send/:id', to: 'invoices#email_send', as: :send_invoice
  post 'invoices/create-monthly-for/:leadset_id', to: 'invoices#create_monthly_pdf', as: :create_monthly_invoice_for_leadset
  post 'invoices/create-pdf',    to: 'invoices#create_pdf',    as: :create_invoice_pdf
  post 'invoices/create-stripe', to: 'invoices#create_stripe', as: :create_invoice_stripe
  get  'invoices/new_pdf',       to: 'invoices#new_pdf',       as: :new_invoice_pdf
  get  'invoices/new_stripe',    to: 'invoices#new_stripe',    as: :new_invoice_stripe
  post 'invoices/:id/send-stripe', to: 'invoices#send_stripe', as: :send_invoice_stripe
  resources :invoices

  get 'iro_positins/roll_prep/:id', to: 'iro_purses#roll_prep', as: :iro_roll_prep
  resources :iro_positions

  get 'iro/max_pain/:ticker/on/:date', to: 'iro_option_gets#max_pain', as: :max_pain
  resources :iro_option_gets

  patch 'iro_purses/:id/show', to: 'iro_purses#update'
  get 'iro_purses/:id/edit',   to: 'iro_purses#edit', as: :edit_iro_purse
  get 'iro_purses/:id/:kind',  to: 'iro_purses#show', as: :iro_purse, defaults: { kind: 'show' } # kind: show_gameui
  resources :iro_purses

  resources :iro_strategies

  resources :iro_watches



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

  post :email_actions, to: 'email_actions#update'
  resources :email_actions

  post 'email_campaigns/:id/send', to: 'email_campaigns#do_send', as: :send_email_campaign
  resources :email_campaigns

  resources :email_campaign_leads # , as: :campaign_leads

  resources :email_filters

  get 'email_messages/iframe/:id',   to: 'email_messages#show_iframe',   as: :email_message_iframe
  get 'email_messages/source/:id',   to: 'email_messages#show_source',   as: :email_message_source
  get 'email_messages/stripped/:id', to: 'email_messages#show_stripped', as: :email_message_stripped
  resources :email_messages

  get 'email_conversations',                   to: 'email_conversations#index'
  get 'email_conversations/in/:slug',          to: 'email_conversations#index',         as: :email_conversations_in
  get 'email_conversations/notin/:not_slug',   to: 'email_conversations#index',         as: :email_conversations_notin
  get 'email_conversations/show/:id',          to: 'email_conversations#show',          as: :email_conversation

  get 'email_contexts/summary', to: 'email_contexts#summary',                           as: :email_contexts_summary
  get  'email_contexts/for_lead/:lead_id',       to: 'email_contexts#index',            as: :email_contexts_for_lead
  get  'email_contexts/iframe_src/:id',          to: 'email_contexts#iframe_src',       as: :email_context_iframe
  get  'email_contexts/new_with_template/:template_slug', to: 'email_contexts#new'
  post 'email_contexts/send_schedule/:id',       to: 'email_contexts#send_schedule',    as: :send_schedule_email_context
  post 'email_contexts/send_immediate/:id',      to: 'email_contexts#send_immediate',   as: :send_immediate_email_context
  get  'email_contexts',                         to: 'email_contexts#index',            as: :email_contexts
  resources :email_contexts

  get    'email_templates/iframe_src/:id', to: 'email_templates#iframe_src', as: :email_template_iframe
  get    'email_templates/show/:id',       to: 'email_templates#show',       as: :email_template
  patch  'email_templates/show/:id',       to: 'email_templates#update'
  delete 'email_templates/show/:id',       to: 'email_templates#destroy'
  resources :email_templates

  resources :email_unsubscribes

  ## L
  resources :lead_actions
  resources :lead_leadsets

  get 'leads',      :to => 'leads#index'
  post 'leads/bulkop', to: 'leads#bulkop'
  post 'leads/import', to: 'leads#import', as: :leads_import
  resources :leads

  resources :leadsets

  resources :leadset_tags

  resources :lead_actions
  resources :lead_action_templates

  ## M

  resources :meetings

  ## N

  resources :newsitems

  ## O

  resources :office_actions

  ## P

  resources :photos
  resources :payments
  resources :prices
  resources :products

  resources :reports

  resources :serverhosts
  resources :scheduled_email_actions

  get 'subscriptions/new_stripe', to: 'subscriptions#new_stripe', as: :new_stripe_subscription
  get 'subscriptions/new_wco',    to: 'subscriptions#new_wco',    as: :new_wco_subscription
  resources :subscriptions

  ##
  ## U
  ##
  resources :unsubscribes

  resources :user_profiles do
    resources :newsitems
  end
  resources :user_profiles, :as => :profiles do
    # resources :newsitems
  end

  ##
  ## V
  ##
  resources :videos

  resources :wco_leadsets

end
