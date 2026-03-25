class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  include SilverImageUploaderMounter
  include RemoveAttributeIfChecked

  class_attribute :pending_propagations, default: 0
  class_attribute :association_records_visited, default: []

  # Propaga los errores de las asociaciones al objeto padre
  validate :propagate_association_errors

  private

  def propagate_association_errors
    ApplicationRecord.pending_propagations  += 1
    ApplicationRecord.association_records_visited << self
    self.class.reflect_on_all_associations.each do |assoc|
      next unless association(assoc.name).loaded?
      Array(send(assoc.name)).each do |record|
        next if record.nil?
        next if ApplicationRecord.association_records_visited.include?(record)
        next unless record.new_record? || record.has_changes_to_save?
        next if record.valid?
        record.errors.full_messages.each do |msg|
          errors.add(assoc.name, "#{assoc.name.to_s.humanize} (#{error_coalesce(default: record.id){record.nombre}}): {#{msg}}")
        end
      end
    end
    ApplicationRecord.pending_propagations  += -1
    if ApplicationRecord.pending_propagations  == 0
      ApplicationRecord.association_records_visited = []
    end
  end
end
