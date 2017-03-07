Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "products#index"
  post '/add-to-cart', to: 'sessions#add_to_cart'
  put '/remove-item', to: 'sessions#remove_item'
  put '/update-item-quantity', to: 'sessions#update_item_quantity'
  get '/view-order', to: 'orders#show'
  get '/checkout', to: 'orders#new'
  get '/orders/status', to: 'orders#status'

  namespace :admin do
    resources :products, :orders
    put '/change-status', to: 'orders#change_status'
  end
  resources :products, :categories
  resources :orders, only: [:create,:index]
end
