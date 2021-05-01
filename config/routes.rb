Rails.application.routes.draw do
  devise_for :users
  resources :drivers do
    get :rides, on: :member
    resources :rides, only: [] do
      post :update_status, on: :member
    end
  end
  resources :rides do
    post :accept_ride, on: :member
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
