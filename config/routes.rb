Rails.application.routes.draw do
  root  'static_pages/home'
  get   'static_pages/contact'  => 'static_pages#contact'
  get   'static_pages/home'     => 'static_pages#home'
  get   'static_pages/help'     => 'static_pages#help'
  get   'static_pages/about'    => 'static_pages#about'
end
