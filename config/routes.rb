Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :quizzes do
        resources :questions, shallow: true  do
          resources :answers
        end
        resources :lobbies, shallow: true do
          resources :players do
            resources :player_answers
          end
        end
      end

      resources :users

      post :login, to: 'sessions#login'
      get :me, to: 'sessions#me'
      delete :logout, to: 'sessions#logout'
    end
  end
end
