Rails.application.routes.draw do
  root 'home#index'
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'log_out', to: 'sessions#destroy', as: 'log_out'

  namespace :api, {format: 'json'} do
    resources :calendar, only: %i[show]
    resources :study_time_records, only: %i[destroy]
  end

  resources :sessions, only: %i[create destroy]
end
