Rails.application.routes.draw do

  # statics
  root 'static_pages#home'
  get  '/home',    to: redirect('/')
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'

  # user creation and display
  resources :users
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  resources :account_activations, only: [:edit]

  # login/logout
  get    '/login',  to: 'sessions#new'
  post   'login',   to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
