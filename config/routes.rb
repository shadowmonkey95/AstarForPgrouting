Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :ways
  get 'ways/find_path' => 'ways#find_path', as: :find_path
end
