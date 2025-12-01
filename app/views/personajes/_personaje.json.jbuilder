json.extract! personaje, :id, :user_id, :nombre, :created_at, :updated_at
json.url personaje_url(personaje, format: :json)
