Rails.application.routes.draw do
  resources :transaction

  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'
  post 'addFunds', to: 'users#addFunds'
  post 'removeFunds', to: 'users#removeFunds'
  get 'info', to: 'users#info'
end
