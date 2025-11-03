class Categ < ApplicationRecord
    # atributes: nombre
    has_and_belongs_to_many :items
    has_and_belongs_to_many :habilidads
    has_and_belongs_to_many :clases
    has_and_belongs_to_many :contextoloots
end
