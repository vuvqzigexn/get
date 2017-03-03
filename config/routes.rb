Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "products#index"
  post '/add-to-cart', to: 'sessions#add_to_cart'
  get '/view-order', to: 'orders#show'
  resources :products, :categories
end
