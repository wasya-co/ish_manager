IshManager::Engine.routes.draw do
  root :to => 'application#home'

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

  resources :events

  resources :features

  resources :galleries do
    post 'multiadd', :to => 'photos#j_create', :as => :multiadd
  end

  resources :newsitems

  resources :photos

  resources :reports

  resources :sites do
    resources :features
    resources :galleries
    resources :newsitems
    resources :reports
  end
  
  get 'ally', :to => 'ally#home', :as => :ally_root
  resources :stock_actions
  resources :stock_options
  resources :stock_watches

  resources :tags

  resources :user_profiles
  resources :user_profiles, :as => :ish_models_user_profiles

  resources :venues
  resources :videos
  
end
