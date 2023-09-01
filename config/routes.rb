Rails.application.routes.draw do
  resources :genders
  devise_for :users
  authenticated :user do
    root "offers#index", as: :authenticated_root
  end

  root 'landing_page#index'
end
