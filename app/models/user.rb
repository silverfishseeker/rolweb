class User < ApplicationRecord
  # atributes:
  #   email, nombre,
  #   encrypted_password, reset_password_token, reset_password_sent_at
  #   remember_created_at, rango
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :personajes, dependent: :destroy
end
