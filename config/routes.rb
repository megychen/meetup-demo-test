Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :meetups do
    resources :comments
  end

  namespace :api, :defaults => { :format => :json } do
    namespace :v1 do
      get "/meetups" => "meetups#index", :as => :meetups
      resources :sessions, only: [:create]
    end
  end

  root 'meetups#index'
end
