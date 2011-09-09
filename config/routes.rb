Thesis::Application.routes.draw do

  resources :projects do
    resources :notes
    resources :papers do
      member do
        get :reference
        get :remove
      end
    end
  end

  resources :terms do
    resources :definitions
  end

  resources :papers do
    resources :notes
    member do
      get :view
      get :download
    end
  end

  match "/auth/:provider/callback" => "sessions#create"
  match "/auth/signout" => "sessions#destroy", :as => :logout

  root :to => "application#index"
end
