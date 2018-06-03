Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get 'activities/index'

  get :search, controller: :main
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :ways

  # resources :requests
  get :requests, controller: :all_requests
  delete 'requests/:id/destroy' => 'requests#destroy', as: :requests_destroy
  resources :users do
    resources :shops do
      resources :requests
    end
  end


  resources :shippers do
    collection do
      post :register
      post :login
      post :set_shipper_status
      post :update_shipper
    end
    resources :locations do
      collection do
        post :setLocation
      end
    end
  end

  resources :locations
  resources :invoices do
    collection do
      post :mark_as_read
      post :create_invoice
      get :shipper_get_invoices
    end
  end
  resources :paths
  resources :activities

  resources :anothers do
    get :get_shop
    get :get_invoices
    post :set_invoice
    post :accept_booking
    post :cancel_booking
    post :create_shop
    post :test
    post :set_request_status
  end

  get 'ways/find_path' => 'ways#find_path', as: :find_path
  root 'shops#index'
  mount ActionCable.server => '/cable'
  # devise_scope :user do
  #   root to: "devise/sessions#new"
  # end
  # put "/users/:user_id/shops/:shop_id/requests/:id/edit" => "requests#edit"
end
