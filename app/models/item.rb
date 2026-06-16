class Item < ApplicationRecord
  # atributes: nombre, coste, peso, efecto, image, usecategloot
  has_rich_text :efecto # En vista de usuario usar full_efecto y no efecto

  mount_image_uploader

  remove_attribute_if_checked :image

  has_and_belongs_to_many :clases
  has_and_belongs_to_many :habilidads
  has_and_belongs_to_many :mobs
  has_and_belongs_to_many :categs
  has_and_belongs_to_many :contextoloots

  has_one :ritual, class_name: 'Ritual::Ritual', foreign_key: 'item_id', dependent: :destroy
  accepts_nested_attributes_for :ritual, allow_destroy: true
  def es_ritual; ritual.present? end # virtual attribute
  def es_ritual=(_value) end # we do nothing on set

  def sub_rd(src, propiedades)
    src.each do |rel|
      valor = yield rel
      valor = "#{rel.cantidad}X" + valor if rel.cantidad > 1
      propiedades << valor
    end
  end

  def ritual_description
    return "" unless es_ritual
    propiedades = []
    sub_rd(ritual.ritual_nivel_rel_rituals, propiedades) do |rel|
      "nivel#{rel.ritual_nivel.valor}"
    end
    sub_rd(ritual.ritual_clase_rel_rituals, propiedades) do |rel|
      rel.ritual_clase.valor
    end
    sub_rd(ritual.ritual_coste_rel_rituals, propiedades) do |rel|
      rel.ritual_coste.valor
    end
    "{#{propiedades.join(', ')}} "
  end

  def all_contextoloots
    if usecategloot
      (contextoloots.to_a + categs.flat_map { |categ| categ.contextoloots.to_a }).uniq
    else
      contextoloots.to_a
    end
  end

  def build_personaje_has_item(personaje)
    Pj::PersonajeHasItem.new(personaje: personaje, item: self, cantidad: 1)
  end
end
