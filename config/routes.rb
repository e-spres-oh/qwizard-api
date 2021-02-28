Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :quizzes do
        get 'suggest_question', action: :suggest_question, on: :collection
        post 'upload_image', action: :upload_image, on: :member

        resources :questions, shallow: true do
          post 'upload_image', action: :upload_image, on: :member

          resources :answers, shallow: true
        end

        resources :lobbies, shallow: true do
          post :answer, on: :member
          post :join, on: :member
          post :start, on: :member
          get :score, on: :member
          get :players_done, on: :member

          resources :players, shallow: true do
            resources :player_answers, shallow: true
          end
        end
      end

      get 'lobbies/from_code/:code', to: 'lobbies#from_code', as: :lobby_from_code

      resources :users do
        post :recover_password, on: :member
      end

      post :login, to: 'sessions#login'
      get :me, to: 'sessions#me'
      delete :logout, to: 'sessions#logout'
    end
  end
end
