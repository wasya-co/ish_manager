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
  end

  resources :email_templates
  resources :events

  resources :feature
  resources :friends

  resources :galleries do
    post 'multiadd', :to => 'photos#j_create', :as => :multiadd
  end

  resources :invoices do
    resources :payments
  end

  get 'leads',      :to => 'leads#index', :defaults => { :is_done => false }
  get 'leads/done', :to => 'leads#index', :defaults => { :is_done => true }, :as => :done_leads
  resources :leads

  resources :newsitems

  resources :orders

  resources :photos
  resources :payments

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
  
  resources :stock_actions
  resources :stock_options
  resources :stock_watches

  resources :tags

  resources :user_profiles
  # resources :user_profiles, :as => :ish_models_user_profiles
  resources :user_profiles, :as => :profiles

  resources :venues
  resources :videos
  
end
