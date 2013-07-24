Mime::Application.routes.draw do

#  mount Ckeditor::Engine => '/ckeditor'
#
  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}
  devise_scope :user do
    constraints :id => /[^\/]*/ do
      resources :users, :path => 'bidragsytere', :controller => 'users/sessions', :only => [:show, :index, :edit] do
        resources :articles, :path => 'artikler', :only => [:index]
      end
    end
    get "users/current" => "users/sessions#current", :defaults => {:format => 'json'}
  end

  match 'search', :to => 'search#new'
  match 'fastsearch', :to => 'json_search#new'
  
  resource :js, :only => :show

  resources :pages, :path => 'p', :except => [:index] do
    resources :manual_article_lists, :path => 'manuelle_lister'
    resources :sorted_article_lists, :path => 'sorterte_lister'
    resources :tags_article_lists, :path => 'nokkelord_lister'
  end

  # TODO - flyttes inn i admin
  get 'home/last_updated'

  constraints :id => /.*/ do
    resources :articles, :except => [:index] do
      resources :versions, :only => [:index]
      resources :images, :only => [:index, :create, :update]
      resource :diff, :only => :show
      get :random, :on => :collection
    end
  end

  constraints(lambda { |req| !req.params[:slug].match(/^assets/) }) do
    # /a, /A, /b, /B, ...,  /æ, /Æ, /ø, /Ø, /å, /Å, /1, /2, ...
    constraints(lambda { |req| req.params[:slug].size == 1 }) do
      match '/:slug' => 'home#alphabetic', :as => :alphabetic, :slug => /.*/
    end

    # Oppslagsord
    constraints(lambda { |req| req.params[:slug].size >= 2 }) do
      get '/:slug' => 'articles#show', :as => :pretty_article, :slug => /.*/
    end
  end

  root :to => 'home#index'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get :short
  #       post :toggle
  #     end
  #
  #     collection do
  #       get :sold
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get :recent, :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
