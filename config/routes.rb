Rails.application.routes.draw do

  namespace :admin do
    resources :settings,
              only: [ :index, :create ]

    resources :pages,
              path: '/',
              only: [] do

      collection do
        get :dashboard
      end
    end
    
    resources :users, only: [ :index ]
  end

  devise_for :users, controllers: {
    sessions:      'users/sessions',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations',
    passwords:     'users/passwords',
    unlocks:       'users/unlocks',
  }

  root to: "pages#home"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
