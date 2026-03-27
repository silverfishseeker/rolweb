class Clase < ApplicationRecord
  # atributes: nombre, efecto, descripcion, image, oculto, raza, radical
  has_rich_text :efecto
  has_rich_text :descripcion
  
  mount_image_uploader(mode: :cut_to_fit)

  has_and_belongs_to_many :habilidads
  has_and_belongs_to_many :items
  has_and_belongs_to_many :categs

  has_and_belongs_to_many :parents,
                          class_name: 'Clase',
                          join_table: 'clases_relations',
                          foreign_key: 'child_id',
                          association_foreign_key: 'parent_id'

  has_and_belongs_to_many :childs,
                          class_name: 'Clase',
                          join_table: 'clases_relations',
                          foreign_key: 'parent_id',
                          association_foreign_key: 'child_id'

  def build_personaje_has_clase(personaje)
    Pj::PersonajeHasClase.new(clase: self, personaje: personaje, nivel: 1, sobreescritura: nil)
  end                 
end
