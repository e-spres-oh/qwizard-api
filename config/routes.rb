Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :quizzes
      
      # get '/questions', to: 'questions#index'
      # post '/questions', to: 'questions#create'
      # delete '/questions/:id', to: 'questions#destroy'
      # put '/questions/:id', to: 'questions#update'
      # get '/questions/:id', to: 'questions#show'

      resources :questions
    end
  end
end
