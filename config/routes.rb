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
  
  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    # Protect against timing attacks:
    # - See https://codahale.com/a-lesson-in-timing-attacks/
    # - See https://thisdata.com/blog/timing-attacks-against-string-comparison/
    # - Use & (do not use &&) so that it doesn't short circuit.
    # - Use digests to stop length information leaking (see also ActiveSupport::SecurityUtils.variable_size_secure_compare)
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USERNAME"])) &
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"]))
  end #if Rails.env.production?
  mount Sidekiq::Web => '/admin/sidekiq'
end

Spree::Core::Engine.routes.draw do
  get '/not-found', to: 'errors#not_found', as: "page_not_found"
  get 'refresh_cart_bag', to: 'custom_checkout#refresh_shopping_cart_bag'

  # Custom error pages
  match "/404", to: "errors#not_found", via: :all
  match "/422", to: "errors#rejected", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
end

Spree::Core::Engine.add_routes do
  get 'new_checkout_address', to: 'addresses#new_checkout_address'
  get '/set_address_as_default', to: 'addresses#set_as_default'
  get '/set_cc_as_default', to: 'user_credit_cards#set_as_default'
  get 'load_existing_ccs', to: 'checkout#load_existing_ccs'
  get 'load_new_cc', to: 'checkout#load_new_cc'
  post 'add_to_cart/:id', to: 'add_to_cart#create', as: :add_to_cart
  get 'all-categories', action: :all_categories, controller: 'taxons', as: :all_categories
  get 'search', to: 'products#search', as: :search

  resources :user_credit_cards
end

Spree::Core::Engine.routes.draw  do
  get '/articles/flavor-powders',  action: :show, controller: 'pages', p: 'flavor_powders', :as => :flavor_powders
  get '/articles/flavor-emulsions',  action: :show, controller: 'pages', p: 'flavor_emulsions', :as => :flavor_emulsions
  get '/articles/flavor-concentrates',  action: :show, controller: 'pages', p: 'flavor_concentrates', :as => :flavor_concentrates
  get '/articles/flavor-extracts',  action: :show, controller: 'pages', p: 'flavor_extracts', :as => :flavor_extracts
  get '/articles/flavor-oils',  action: :show, controller: 'pages', p: 'flavor_oils', :as => :flavor_oils
  get '/faq',  action: :show, controller: 'pages', p: 'faq', :as => :faq
  get '/about-us',  action: :show, controller: 'pages', p: 'about_us', :as => :about_us
  get '/shipments-delivery',  action: :show, controller: 'pages', p: 'shipments_delivery', :as => :shipments_delivery
  get '/returns',  action: :show, controller: 'pages', p: 'returns', :as => :returns
  get '/terms-and-conditions-of-use',  action: :show, controller: 'pages', p: 'terms_and_conditions', :as => :terms_and_conditions
  get '/privacy',  action: :show, controller: 'pages', p: 'privacy', :as => :privacy
  get '/beverage-formulation-development',  action: :show, controller: 'pages', p: 'beverage_development', :as => :beverage_development
  get '/route',  action: :show, controller: 'pages', p: 'route', :as => :route
end

Spree::Core::Engine.add_routes do
  resources :doofinder, :controller => 'doofinder/doofinder', :only => [:feed]
  get 'doofinder-feed' => 'doofinder/doofinder#feed', :as => :doofinder_feed
end

Spree::Core::Engine.routes.draw do
  # Override for Production state
  namespace :admin, path: Spree.admin_path do
    resources :orders, except: [:show] do
      get :production, on: :member
      put :set_production, on: :member
      post :create_route_order, on: :member
    end
  end

  # Clear product cache
  namespace :admin, path: Spree.admin_path do
    resources :products, except: [:show] do
      post :clear_product_cache, on: :member
    end
  end

  # ActiveStorage image upload for tinymce
  namespace :admin, path: Spree.admin_path do
    post 'uploader/image'
  end
end