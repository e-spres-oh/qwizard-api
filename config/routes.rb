Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :quizzes
      resources :questions
      resources :answers
      resources :lobbies
      resources :players
      resources :player_answers
      resources :users

      post :login, to: 'sessions#login'
      get :me, to: 'sessions#me'
      delete :logout, to: 'sessions#logout'
    end
  end
end
