class RestoreState < ApplicationRecord
  # attributes: index, resume_dir
  def self.resume_dir
    first_or_create!.resume_dir
  end

  def self.index
    first_or_create!.index
  end

  def self.save (index: nil, resume_dir: nil)
    record = first_or_create!
    record.index = index if index
    record.resume_dir = resume_dir if resume_dir
    record.save!
  end
end
