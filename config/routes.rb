Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :users
      
      resources :quizzes do
        
        resources :questions, shallow: true do
          resources :answers, shallow: true do
            # TODO: define a way to handle this path too
            # resources :player_answers, shallow: true 
          end
        end
        
        resources :lobbies, shallow: true do
          resources :players, shallow: true do
            resources :player_answers, shallow: true
          end
        end

      end


      post :login, to: 'sessions#login'
      get :me, to: 'sessions#me'
      delete :logout, to: 'sessions#logout'
    end
  end
end
