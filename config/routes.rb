 Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index1"

  # This is for our own api (Super Admin)
  namespace :admin_api do
    resources :api_clients, param: :api_client_id
    resources :domains, param: :domain_id
    resources :domain_references, param: :domain_reference_id
    resources :users, param: :user_id, only: %i[index show create update destroy]

    resources :properties, param: :property_id, only: %i[index]
    resources :tenant_applications, param: :tenant_application_id, only: %i[index]
  end

  # This is for our Client or External api (Outside and Limited Access)
  namespace :api do
    resources :domains, only: [:index]
    resources :domain_references, only: [:index]
    resources :users, param: :user_id, only: %i[index update]
    resources :addresses, param: :address_id, only: %i[index create update]
    resources :identities, param: :identity_id, only: %i[index create]
    resources :incomes, param: :income_id, only: %i[index create]
    resources :employments, param: :employment_id, only: %i[index create]
    resources :references, param: :reference_id, only: %i[update]
    resources :flatmates, param: :flatmate_id, only: %i[index create]
    resources :flatmate_members, param: :flatmate_member_id, only: %i[create]
    resources :pets, param: :pet_id, only: %i[index create]
    resources :tenant_applications, param: :tenant_application_id, only: %i[index create]
    resources :properties, param: :property_id, only: %i[create]
    resources :user_properties, param: :user_property_id, only: %i[index]
    resources :user_settings, param: :user_setting_id, only: %i[index update]

    post 'users/mobile_verification', to: 'users#mobile_verification'
    post 'users/resend_otp', to: 'users#resend_otp'
    post 'users/resend_email_verification', to: 'users#resend_email_verification'
    post 'users/setup_avatar', to: 'users#setup_avatar'
    post 'users/update_personal_info', to: 'users#update_personal_info'
    post 'users/update_account', to: 'users#update_account'

    get 'users/:email_token/confirm_email/', to: 'users#confirm_email'
    get 'users/get_users', to: 'users#get_users'
  end

  resources :messages, only: [:index, :create]
  resources :chatrooms, only: [:index, :create, :show]

  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'sign_up'
  }, controllers: { sessions: 'sessions', registrations: 'registrations' }

  post 'authentication', to: 'authentication#authentication'
  post 'refresh_me', to: 'refresh_token#refresh_me'

  post 'password/update_password', to: 'passwords#update_password'
  post 'password/forgot', to: 'passwords#forgot'
  post 'password/reset', to: 'passwords#reset'

  mount ActionCable.server => './cable'
end
