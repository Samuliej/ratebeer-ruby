Rails.application.routes.draw do
  resources :memberships
  resources :beer_clubs
  resources :users
  resources :beers
  resources :breweries do
    post 'toggle_activity', on: :member
  end
  resources :beer_clubs
  resources :styles
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

  # Lisätään vaihtoehtoinen reitti käyttäjän luomiseen
  get 'signup', to: 'users#new'

  resources :ratings, only: [ :index, :new, :create, :destroy ]

  # Yksikössä, eli esimerkiksi kirjautumissivun osoite on nyt session/new
  resource :session, only: [:new, :create, :destroy]

  resources :places, only: [:index, :show]

  post 'places', to: 'places#search'
end
