IshManager::Engine.routes.draw do
  root :to => 'application#home'

  resources :cities
  resources :events
  resources :galleries
  resources :newsitems
  resources :reports
  resources :sites do
    resources :galleries
    resources :reports
  end
  resources :user_profiles
  resources :venues
  resources :videos
  
end
