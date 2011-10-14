Thesis::Application.routes.draw do
  resources :projects do
    member do
      get :backup
      get :bibtex
    end

    resources :notes
    resources :papers do
      member do
        get :reference
        get :remove
      end
    end
    resources :documents
    resources :tasks
  end

  resources :papers do
    resources :notes
    member do
      get :view
      get :download
    end
  end

  resources :documents

  resources :tasks do
    resources :notes
  end

  resources :terms do
    resources :definitions
  end

  match "/auth/:provider/callback" => "sessions#create"
  match "/auth/signout" => "sessions#destroy", :as => :logout

  root :to => "application#index"
end
