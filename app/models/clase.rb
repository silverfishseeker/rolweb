class Clase < ApplicationRecord
    has_and_belongs_to_many :habilidads
    has_and_belongs_to_many :items
    mount_uploader :image, ImageUploader
    
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
end
