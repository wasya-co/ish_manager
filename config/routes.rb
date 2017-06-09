IshManager::Engine.routes.draw do
  root :to => 'application#home'

  resources :cities do
    resources :features
    resources :newsitems
  end
  resources :events
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
  resources :tags
  resources :user_profiles
  resources :venues
  resources :videos
  
end
