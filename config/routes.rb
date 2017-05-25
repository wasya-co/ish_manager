IshManager::Engine.routes.draw do
  root :to => 'application#home'

  resources :cities do
    resources :features
  end
  resources :events
  resources :galleries
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
