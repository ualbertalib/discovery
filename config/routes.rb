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
  get "ebooks/range_limit" => "ebooks#range_limit"
  get "new_books/range_limit" => "new_books#range_limit"

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
end
