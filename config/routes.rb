Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "sessions#new"

  get "signup", to: "users#new", as: "signup"
  get "login", to: "sessions#new", as: "login"
  get "logout", to: "sessions#destroy", as: "logout"

  resources :tickets, only: %i[index new create show] do
    collection do
      get "export"
    end

    member do
      resources :comments
      patch "process", to: "ticket_status#start_process"
      patch "close", to: "ticket_status#close"
      patch "reset", to: "ticket_status#reset"
    end
  end

  resources :exports, only: %i[create]

  resources :sessions, only: %i[create destroy]

  resources :users, only: %i[new create]
  
  namespace :admin do
    resources :dashboards, only: %i[index]
    resources :agents, only: [] do
      member do
        patch "add", to: "agents#add_agent"
        patch "remove", to: "agents#remove_agent"
      end
    end
  end
end
