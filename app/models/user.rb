class User < ApplicationRecord
  # atributes:
  #   email, nombre, image
  #   encrypted_password, reset_password_token, reset_password_sent_at
  #   remember_created_at, rango
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  validates :nombre,
    presence:   { message: "no puede estar vacío." },
    uniqueness: { message: "ya está registrado, elige otro." }

  validate on: :update do
    if email_changed? && self.persisted?
      errors.add(:email, "no se puede cambiar una vez registrado.")
    end
  end

  validates :rango, inclusion: {
    in: AccessControl::VALID_RANGE,
    message: "no es un rango válido."
  }

  mount_image_uploader
  
  has_many :personajes, dependent: :destroy
  has_and_belongs_to_many :viewPersonajes, class_name: "Personaje", join_table: "personajes_users"
  has_and_belongs_to_many :personajegroups

  def rango_nombre
    AccessControl::LEVELS_NAMES[rango] || "Inválido"
  end
end
