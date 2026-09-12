class Pj::Modificable < ApplicationRecord
  #attributes: passive_mod, active_mod
  belongs_to :owner, polymorphic: true
end
