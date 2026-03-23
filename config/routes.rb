Rails.application.routes.draw do
  resource :session, only: %i[new create destroy]
  resources :passwords, param: :token
  resource :registration, only: %i[new create]

  resources :pages, param: :slug, only: %i[index new create]

  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#index"

  get "/:slug/edit", to: "pages#edit", as: :edit_page
  patch "/:slug", to: "pages#update"
  get "/:slug", to: "pages#show", as: :page
end
