class Ritual::Ritual < ApplicationRecord
  # atributes: none
  belongs_to :item, class_name: '::Item', foreign_key: 'item_id', optional: true

  has_many :ritual_clase_rel_rituals, dependent: :destroy
  has_many :ritual_coste_rel_rituals, dependent: :destroy
  has_many :ritual_nivel_rel_rituals, dependent: :destroy
  
  accepts_nested_attributes_for :ritual_clase_rel_rituals, allow_destroy: true
  accepts_nested_attributes_for :ritual_coste_rel_rituals, allow_destroy: true
  accepts_nested_attributes_for :ritual_nivel_rel_rituals, allow_destroy: true
end
