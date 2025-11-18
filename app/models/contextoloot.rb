class Contextoloot < ApplicationRecord
  # attributes: nombre
  has_and_belongs_to_many :items
  has_and_belongs_to_many :categs
end
