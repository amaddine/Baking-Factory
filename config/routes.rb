Rails.application.routes.draw do
  
  get 'sessions/new'

  get 'sessions/create'

  get 'sessions/destroy'

  get 'item_price/index'

  get 'item_price/show'

  get 'item_price/new'

  get 'item_price/edit'

  get 'item_price/create'

  get 'item_price/update'

  get 'item_price/destroy'

  get 'users/index'

  get 'users/new'

  get 'users/edit'

  get 'users/create'

  get 'users/update'

  get 'users/destroy'

  get 'order_items/index'

  get 'order_items/show'

  get 'order_items/new'

  get 'order_items/edit'

  get 'order_items/create'

  get 'order_items/update'

  get 'order_items/destroy'

  # Routes for main resources
  resources :sessions




  resources :addresses
  resources :customers
  resources :orders
  resources :order_items
  resources :item_prices
  resources :users
  
  resources :items
  get 'item/:id/add_to_cart' => "items#add_to_cart", as: :add_to_cart
  get 'view_cart/remove_from_cart/:id' => "items#remove_from_cart", as: :remove_from_cart
  
  get 'users/new', to: 'users#new', as: :signup
  get 'user/edit', to: 'users#edit', as: :edit_current_user
  get 'login', to: 'sessions#new', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout
  get 'view_cart', to: 'sessions#view_cart', as: :view_cart

  # Semi-static page routes
  get 'home' => 'home#home', as: :home
  get 'about' => 'home#about', as: :about
  get 'contact' => 'home#contact', as: :contact
  get 'privacy' => 'home#privacy', as: :privacy
  get 'home/search', to: 'home#search', as: :search
  
  # Set the root url
  root :to => 'home#home'
  
end
