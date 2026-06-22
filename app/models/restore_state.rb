class RestoreState < ApplicationRecord
  # attributes: index

  def self.get
    first_or_create!.index
  end

  def self.set (index)
    first_or_create!.update!(index: index)
  end
end
