class Personajegroup < ApplicationRecord
  # attributes: nombre
  
  has_many :personajes, dependent: :nullify
  has_and_belongs_to_many :users

  validates :nombre, presence: true, uniqueness: { message: "ya existe otro grupo con ese nombre." }

end
