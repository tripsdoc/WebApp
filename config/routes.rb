Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get 'notification_jobs/new'
  
  root 'containers#index'

  mount ContainerData::Base => '/'

  resources :containers do
    collection do
      post :search
      post :search_hbl
    end
  end

  get 'privacy' => 'static_pages#privacy', as: :privacy

  resources :notifications, only: [:create]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
