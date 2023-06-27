Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "clases#index"
  resources :clases
  resources :habilidads
  resources :items
  get '/reglas', to: 'info#reglas'
  get '/estadosAlterados', to: 'info#estadosAlterados'
  get '/habilidadesIndependientes', to: 'habilidads#habilidadesIndependientes'
end
