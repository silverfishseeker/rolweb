Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "info#home"

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  resources :users
  
  resources :clases
  resources :habilidads
  resources :items
  resources :pictures
  resources :mobs
  resources :categs
  resources :estadoalterados
  resources :dndspells
  resources :etiquets
  resources :contextoloots
  resources :cuentos
  get '/recalcular_childs', to: 'cuentos#recalcular_childs'
  resources :personajes
  
  resource :adminsession, only: [:new, :create]
  get '/adminsession/close', to: 'adminsessions#close'
  
  namespace :ritual do
    resources :ritual_nivels
    resources :ritual_costes
    resources :ritual_clases
  end

  namespace :pj do
    resources :meta_tipos, controller: 'meta_tipos', path: 'calculado', as: 'tipo_calculados', defaults: { tipo: 'calculado' }
    resources :meta_tipos, controller: 'meta_tipos', path: 'estadistic', as: 'tipo_estadistics', defaults: { tipo: 'estadistic' }
    resources :meta_tipos, controller: 'meta_tipos', path: 'rango', as: 'tipo_rangos', defaults: { tipo: 'rango' }
  end

  resource :profile, only: [:edit, :update, :destroy] do
    collection do
      get 'dashboard'
      get 'confirm_destroy'
    end
  end

  get 'images/:id/download', to: 'images#download', as: 'download_image'

  get '/reglas', to: 'info#reglas'
  get '/estadosAlterados', to: 'info#estadosAlterados'
  get '/avisolegal', to: 'info#avisolegal'
  get '/clases-arbol', to: 'info#arbol'
  get '/get_random_element', to: 'info#get_random_element'
  get '/newPlayersHelp', to: 'info#newPlayersHelp'
  get '/rangosInfo', to: 'info#rangosInfo'

  get '/control', to: 'admin#control'
  get '/items_no_categ', to: 'admin#items_no_categ'
  get '/habilidads_ocultas', to: 'admin#habilidads_ocultas'
  get '/habilidads_sueltas', to: 'admin#habilidads_sueltas'
  get '/delete_disk_cache', to: 'admin#delete_disk_cache'
  get '/delete_navbar_cache', to: 'admin#delete_navbar_cache'
  get '/delete_all_cache', to: 'admin#delete_all_cache'
  get '/delete_session_data', to: 'admin#delete_session_data'
  get '/backup', to: 'admin#backup'
  get '/prepare_backup', to: 'admin#prepare_backup'
  get '/create_backup', to: 'admin#create_backup'
  post '/restore_backup', to: 'admin#restore_backup'
  get '/download_logs', to: 'admin#download_logs'
  get '/check_minio_connection', to: 'admin#check_minio_connection'
  get '/ritual', to: 'admin#ritual'
  get '/test_mail', to: 'admin#test_mail'

  get '/lootbox', to: 'randompick#lootbox'
  post '/lootboxing', to: 'randompick#lootboxing'
  get '/resetdndspells', to: 'dndspells#reset'
  get '/clasificar_habilidad', to: 'habilidads#clasificar'
end
