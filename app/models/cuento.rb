class Cuento < ApplicationRecord
  # nombre, titulo, spoilers, texto, prioridad, oculto
  has_rich_text :texto

  has_and_belongs_to_many :etiquets
  has_and_belongs_to_many :pictures
  has_and_belongs_to_many :mobs

  has_and_belongs_to_many :parents,
                          class_name: 'Cuento',
                          join_table: 'cuento_relations',
                          foreign_key: 'child_id',
                          association_foreign_key: 'parent_id'

  has_and_belongs_to_many :childs,
                          class_name: 'Cuento',
                          join_table: 'cuento_relations',
                          foreign_key: 'parent_id',
                          association_foreign_key: 'child_id'
end
