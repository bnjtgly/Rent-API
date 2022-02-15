Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # This is for our Client or External api (Outside and Limited Access)
  namespace :api do
    resources :domains, only: [:index]
    resources :domain_references, only: [:index]
    resources :users, param: :user_id, only: %i[index]

    post 'users/mobile_verification', to: 'users#mobile_verification'
    post 'users/resend_otp', to: 'users#resend_otp'
  end

  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'sign_up'
  }, controllers: { sessions: 'sessions', registrations: 'registrations' }

  post 'authentication', to: 'authentication#authentication'
  post 'refresh_me', to: 'refresh_token#refresh_me'
  post 'password/forgot', to: 'passwords#forgot'
  post 'password/reset', to: 'passwords#reset'
end
