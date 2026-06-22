class Pj::PersonajeHasItem < ApplicationRecord
  #attributes: cantidad, sobreescritura, position, isEquipped
  belongs_to :personaje
  belongs_to :item, optional: true

  
  has_one :customitem, class_name: "Pj::Customitem", dependent: :destroy
  has_many :calculados, as: :hasCalculados, class_name: "Pj::Calculado", dependent: :destroy, autosave: true, inverse_of: :hasCalculados
  
  has_rich_text :sobreescritura

  validate do
    if item.present? == customitem.present?
      errors.add( :base, "Debe tener un item o un customitem, pero no ambos ni ninguno" )
    end
  end

  scope :ordered, -> { joins(:item).order("items.nombre") }
end
