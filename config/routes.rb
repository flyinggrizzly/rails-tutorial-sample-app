Rails.application.routes.draw do

  root 'static_pages#home'
  get  '/home',    to: redirect('/')
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'



  resources :users
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
end
