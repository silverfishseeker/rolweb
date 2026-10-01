class MobHasItem < ApplicationRecord
  # atributes: cantidad
  belongs_to :mob
  belongs_to :item
end
