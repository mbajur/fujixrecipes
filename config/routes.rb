Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'callbacks' }
  resources :users, only: [:show, :edit, :update], path: '', param: :username do
    resources :recipes, only: [:show], param: :hashid do
      get :saved, on: :collection
    end
  end
  resources :recipes, only: [:index, :new, :create, :edit, :update], param: :hashid do
    post :toggle_save
    get :new_local, on: :collection
    get :new_external, on: :collection
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get 'cameras/:slug', as: :camera, to: 'recipes#camera'
  get 'sensors/:slug', as: :sensor, to: 'recipes#sensor'

  # Defines the root path route ("/")
  root "recipes#index"
end
