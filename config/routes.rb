Rails.application.routes.draw do

  get 'errors/file_not_found'

  get 'errors/unprocessable'

  get 'errors/internal_server_error'

  blacklight_for :catalog, :journals, :databases, :symphony, :ebooks, :new_books
  Blacklight::Marc.add_routes(self)

  devise_for :users

  get "symphony/range_limit" => "symphony#range_limit"
  get "journals/range_limit" => "journals#range_limit"
  get "databases/range_limit" => "databases#range_limit"
  get "articles/range_limit" => "articles#range_limit"
  get "ebooks/range_limit" => "ebooks#range_limit"
  get "new_books/range_limit" => "new_books#range_limit"

  get "articles", to: "articles#index"
  get "articles/:dbid/:an", to: "articles#detail", constraints: {an: /[^V]+/ }
  get "articles/:dbid/:an/fulltext", to: "articles#fulltext", constraints: {an: /[^V]+/ }
  get "articles/switch", to: "articles#recordSwitch"

  get "/advanced", to: "advanced#index"
  
  get "/permalink/opac/:id/:user", to: redirect("http://neos.library.ualberta.ca/uhtbin/cgisirsi/x/0/0/57/5?searchdata1=%{id}{001}&user_id=%{user}")

  get "/permalink/opac/:id", to: redirect("http://neos.library.ualberta.ca/uhtbin/cgisirsi/x/0/0/57/5?searchdata1=%{id}{001}&user_id=WUAARCHIVE")

  get "/permalink/opac_fr/:id/:user", to: redirect("http://neos.library.ualberta.ca/uhtbin/cgisirsi/x/0/0/57/5?searchdata1=%{id}{001}&user_id=%{user}")

  get "/permalink/opac_fr/:id", to: redirect("http://neos.library.ualberta.ca/uhtbin/cgisirsi/x/0/0/57/5?searchdata1=%{id}{001}&user_id=WUAARCHIVE")

  match '/404', to: 'errors#file_not_found', via: :all
  match '/422', to: 'errors#unprocessable', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
  
  resources :staff, :as => :profiles, :controller => :profiles
  
  resources :forms 
  post "forms/send_email" => "forms#send_email"

  root to: "comfy/cms/content#show"

  comfy_route :cms_admin, :path => '/admin'

  # Make sure this routeset is defined last
  comfy_route :cms, :path => '/', :sitemap => false

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
