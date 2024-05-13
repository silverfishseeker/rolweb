Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "clases#index"
  resources :clases
  resources :habilidads
  resources :items
  resources :pictures
  resources :mobs
  resources :categs
  resources :estadoalterados
  get '/reglas', to: 'info#reglas'
  get '/estadosAlterados', to: 'info#estadosAlterados'
  get '/lore', to: 'info#lore'
  get '/avisolegal', to: 'info#avisolegal'
  get '/control', to: 'admin#control'
  get '/items_no_categ', to: 'admin#items_no_categ'
  get '/habilidads_ocultas', to: 'admin#habilidads_ocultas'
  get '/habilidads_sueltas', to: 'admin#habilidads_sueltas'
  get '/lootbox', to: 'randompick#lootbox'
  post '/lootboxing', to: 'randompick#lootboxing'
  get '/clases-arbol', to: 'info#arbol'
end
