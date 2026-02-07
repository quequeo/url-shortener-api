Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  namespace :api do
    namespace :v1 do
      resource :profile, only: %i[show], controller: 'profile'
      resources :links, only: %i[index create show update destroy] do
        resources :visits, only: %i[index]
      end
    end
  end

  get 'up' => 'rails/health#show', as: :rails_health_check

  get '/:short_code', to: 'redirects#show', constraints: { short_code: /[a-zA-Z0-9]+/ }
end
