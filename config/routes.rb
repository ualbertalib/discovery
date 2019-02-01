Rails.application.routes.draw do
  # TODO: These error routes should be deleted. Let rails handle this themselves with proper status codes
  get 'errors/file_not_found'
  get 'errors/unprocessable'
  get 'errors/internal_server_error'

  blacklight_for :catalog, :journals, :databases, :symphony, :ebooks
  Blacklight::Marc.add_routes(self)

  devise_for :users

  get 'symphony/range_limit' => 'symphony#range_limit'
  get 'journals/range_limit' => 'journals#range_limit'
  get 'databases/range_limit' => 'databases#range_limit'
  get 'ebooks/range_limit' => 'ebooks#range_limit'

  # TODO: Should be able to remove this? It is defined twice in the routes, but this fails our tests
  get '/advanced', to: 'advanced#index'

  get '/permalink/opac/:id/:user', to: redirect('http://neos.library.ualberta.ca/uhtbin/cgisirsi/x/0/0/57/5?searchdata1=%{id}{001}&user_id=%{user}')
  get '/permalink/opac/:id', to: redirect('http://neos.library.ualberta.ca/uhtbin/cgisirsi/x/0/0/57/5?searchdata1=%{id}{001}&user_id=WUAARCHIVE')
  get '/permalink/opac_fr/:id/:user', to: redirect('http://neos.library.ualberta.ca/uhtbin/cgisirsi/x/0/0/57/5?searchdata1=%{id}{001}&user_id=%{user}')
  get '/permalink/opac_fr/:id', to: redirect('http://neos.library.ualberta.ca/uhtbin/cgisirsi/x/0/0/57/5?searchdata1=%{id}{001}&user_id=WUAARCHIVE')

  match '/404', to: 'errors#file_not_found', via: :all
  match '/422', to: 'errors#unprocessable', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

  # We have the actual catalog routes defined from blacklight,
  # this is just so we can get these routes nested nicely with the catalog item's ids in the url
  # e.g: /catalog/1234567/corrections/new
  resources :catalog, only: [] do
    resources :corrections, only: [:new, :create]
  end

  resources :rcrf_special_requests, only: [:new, :create]
  resources :bpsc_read_on_site_requests, only: [:new, :create]
  resources :rcrf_read_on_site_requests, only: [:new, :create]

  root to: 'catalog#index'
end
