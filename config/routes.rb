Rails.application.routes.draw do
  root "analyses#new"
  resources :analyses, only: %i[new create show index]
  get "up" => "rails/health#show", as: :rails_health_check
end
