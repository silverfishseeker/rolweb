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

  validate :email_is_immutable, on: :update
  def email_is_immutable
    if email_changed? && self.persisted?
      errors.add(:email, "no se puede cambiar una vez registrado.")
    end
  end

  validates :rango, inclusion: { in: 0..3, message: "no es un rango válido." }

  mount_image_uploader
  
  has_many :personajes, dependent: :destroy

  def self.rangos
    ["Espectador", "Jugador", "Game Master", "Administrador"]
  end

  def rango_nombre
    self.rangos[rango] || "Inválido"
  end
end
