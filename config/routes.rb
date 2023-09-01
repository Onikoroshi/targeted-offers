Rails.application.routes.draw do
  devise_for :users
  authenticated :user do
    root "offers#index", as: :authenticated_root
  end

  root 'landing_page#index'

  resources :offers, only: :index
  # resources :genders # TODO: admin page to manage
end
