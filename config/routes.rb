Growth::Engine.routes.draw do
  root to: 'stats#index'
  
  resources :stats, only: [:index, :show]
  resources :emails, only: [:new, :create]
end