require "active_support/concern"

module SilverImageUploaderMounter
  extend ActiveSupport::Concern

  class << self
    attr_reader :img_uploader
  end

  class_methods do
    def mount_image_uploader(mode: :none)

      class_attribute :has_image_uploader, instance_writer: false, default: true

      # Por ahora esto sólo lo utiliza el img_uploader.rake en reupload_trim para identificar las clases que usan :cut_to_fit
      class_attribute :image_uploader_mode, instance_writer: false
      self.image_uploader_mode = mode

      att = :image

      before_destroy "remove_#{att}!".to_sym

      define_method(:img_uploader) do
        @img_uploader_att ||= SilverImageUploader.new(mode)
      end

      define_method(att) do
        @image ||= img_uploader.get(read_attribute(att))
      end

      define_method("#{att}=") do |file|
        old_id = read_attribute(att)
        id = img_uploader.set(file, old_id)
        write_attribute(att, id)
      end

      define_method("remove_#{att}!") do
        img_uploader.remove!(read_attribute(att))
        write_attribute(att, nil)
      end

    end
  end
end