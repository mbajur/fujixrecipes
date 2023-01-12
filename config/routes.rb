Rails.application.routes.draw do
  devise_for :users

  resources :users, only: [:show, :edit, :update], path: :u, param: :username do
    resources :recipes, only: [:show], param: :hashid do
      get :saved, on: :collection
    end
  end

  resources :recipes, only: [:index, :new, :create, :edit, :update], param: :hashid, path: '/' do
    get :search, on: :collection
    post :toggle_save
    get :new_local, on: :collection
    get :new_external, on: :collection
  end

  match 'cameras/:slug', as: :camera, to: 'recipes#camera', via: [:post, :get]
  match 'sensors/:slug', as: :sensor, to: 'recipes#sensor', via: [:post, :get]

  get :about, to: 'pages#about', as: :about

  root "recipes#index"
end
