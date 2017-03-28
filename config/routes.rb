Rails.application.routes.draw do

  get 'users/new'

  root  'static_pages#home'
  get   '/home',    to: redirect('/')

  get   '/contact', to: 'static_pages#contact'
  get   '/help',    to: 'static_pages#help'
  get   '/about',   to: 'static_pages#about'
  get   '/signup',  to: 'users#new'
end
