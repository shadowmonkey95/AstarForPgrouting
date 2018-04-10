Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :ways

  resources :users do
    resources :shops do
      resources :requests
    end
  end

  resources :shippers do
    collection do
      post :register
      post :login
    end
    resources :locations do
      collection do
        post :setLocation
      end
    end
  end

  resources :locations

  get 'ways/find_path' => 'ways#find_path', as: :find_path
  root 'shops#index'
end
