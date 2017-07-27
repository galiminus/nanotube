Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: {registrations: 'registrations'}
  resources :posts do
    post :like
    post :unlike
  end
  resources :upload, only: [:create]
  
  root to: "posts#index"
end
