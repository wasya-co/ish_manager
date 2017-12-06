Rails.application.routes.draw do
  root :to => 'application#home'

  mount IshManager::Engine => "/ish_manager"

  devise_for :users, :skip => [ :registrations ]
  
end
