Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get 'offers/index'
      post 'offers/choose_offer'
    end
  end

  devise_for :users
  # authenticated :user do
  #   root "offers#index", as: :authenticated_root
  #   get '/*path' => 'api/v1/offers#index'
  # end

  root 'landing_page#index'
  get '/*path' => 'landing_page#index'
end
