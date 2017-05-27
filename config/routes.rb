IshManager::Engine.routes.draw do
  root :to => 'application#home'

  resources :cities do
    resources :features
  end
  resources :events
  resources :galleries do
    post 'multiadd', :to => 'photos#j_create', :as => :multiadd
  end
  resources :newsitems
  resources :reports
  resources :photos
  resources :sites do
    resources :galleries
    resources :reports
  end
  resources :user_profiles
  resources :venues
  resources :videos
  
end
