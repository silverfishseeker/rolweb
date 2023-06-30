Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "clases#index"
  resources :clases
  resources :habilidads
  resources :items
  resources :pictures
  get '/reglas', to: 'info#reglas'
  get '/estadosAlterados', to: 'info#estadosAlterados'
  get '/lore', to: 'info#lore'
  get '/control', to: 'info#control'
  get '/habilidadesIndependientes', to: 'habilidads#habilidadesIndependientes'
end
