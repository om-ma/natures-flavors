Rails.application.routes.draw do
  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to
  # Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the
  # :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being
  # the default of "spree".
  mount Spree::Core::Engine, at: '/'
  #get '*path' => redirect('/not-found')
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
Spree::Core::Engine.routes.draw do
  get '/not-found', to: 'page_not_found#index', as: "page_not_found"
  get 'refresh_cart_bag', to: 'custom_checkout#refresh_shopping_cart_bag'
end
Spree::Core::Engine.add_routes do
    get 'new_checkout_address', to: 'addresses#new_checkout_address'
    get '/set_address_as_default', to: 'addresses#set_as_default'
    get '/set_cc_as_default', to: 'user_credit_cards#set_as_default'
    get 'load_existing_ccs', to: 'checkout#load_existing_ccs'
    get 'load_new_cc', to: 'checkout#load_new_cc'
    resources 'add_to_cart' ,to:'add_to_cart#create'

    resources :user_credit_cards
  end
