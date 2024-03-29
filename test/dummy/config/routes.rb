Rails.application.routes.draw do

  root :to => 'application#home'

  mount IshManager::Engine => "/manager"
  mount Ishapi::Engine, :at => '/api/', as: :ishapi

  devise_for :users, :skip => [ :registrations ], :controllers => {
    :sessions  => 'users/sessions',  :confirmations => 'users/confirmations',
    :passwords => 'users/passwords', :unlocks       => 'users/unlocks'
  }

end
