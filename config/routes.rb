DesignExchange::Application.routes.draw do

  resources :tags

  root "application#index"

  resources :case_studies do
    collection do 
      get "search/:query", to: "application#search"
      get "search", to: "application#search", :as => "search"
    end
  end
  resources :design_methods do
    get :autocomplete, on: :collection
    collection do 
      get "search/:query", to: "application#search"
      get "search", to: "application#search", :as => "search"
    end
  end

  resources :discussions do
    collection do 
      get "search/:query", to: "application#search"
      get "search", to: "application#search", :as => "search"
    end
  end

  resources :set do
    collection do
      get "search/:query", to: "application#search", :as => "search"
      get "search", to: "application#search"
    end
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users

 

  

  resources :method_categories, only: [:show]
  resources :citations, only: [:show]

  resources :users do
    resources :design_methods, only: [:index]
  end

  get 'search/(:query)', controller: 'design_methods', action: 'search', as: 'search'

  get ":action", to:"application##{:action}"

end
