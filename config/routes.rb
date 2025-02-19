Rails.application.routes.draw do
  resources :beers
  resources :breweries
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  # Ohjaa juureen tulevat pyynnöt panimoiden sivulle
  root "breweries#index"

  # Kutsutaan get metodia kahdella parametrillä. merkkijono ja hash
  # Sama kuin kirjoitettaisiin
  # get('kaikki_bisset', { :to => 'beers#index' })
  get "kaikki_bisset", to: "beers#index"

  get "ratings", to: "ratings#index"

  get "ratings/new", to: "ratings#new"

  post "ratings", to: "ratings#create"
end
