Rails.application.routes.draw do
  devise_for :users

  namespace :api do
    namespace :v1 do
      resources :links, only: %i[index create show destroy]
    end
  end

  get 'up' => 'rails/health#show', as: :rails_health_check

  get '/:short_code', to: 'redirects#show', constraints: { short_code: /[a-zA-Z0-9]+/ }
end
