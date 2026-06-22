class SilverImage
  include ImageUrlable

  attr_accessor :id, :data, :nombre, :content_type

  def initialize(id:, data:, nombre:, content_type:)
    @id = id
    @data = data
    @nombre = nombre
    @content_type = content_type
  end
end