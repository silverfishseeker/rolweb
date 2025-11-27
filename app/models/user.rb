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
  
  has_many :personajes, dependent: :destroy

  mount_image_uploader

  def self.rangos
    ["Expectador", "Jugador", "Game Master", "Administrador"]
  end

  def rango_nombre
    self.rangos[rango] || "Inválido"
  end
end
