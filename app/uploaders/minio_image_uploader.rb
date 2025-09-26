require "aws-sdk-s3"
require "securerandom"

class MinioConnectionError < StandardError; end

class MinioImageUploader

  def initialize
    cfxm = Rails.configuration.x.minio
    s3_resource = Aws::S3::Resource.new(
      endpoint: cfxm.endpoint,
      access_key_id: cfxm.access_key_id,
      secret_access_key: cfxm.secret_access_key,
      region: cfxm.region,
      force_path_style: true
    )
    @bucket = s3_resource.bucket(cfxm.bucket)

    unless @bucket.exists?
      begin
        s3_resource.create_bucket(bucket: cfxm.bucket)
      rescue => e
        raise MinioConnectionError, "No se pudo crear el bucket '#{cfxm.bucket}': #{e.message}"
      end
      Rails.logger.warn "⚠️ Se ha creado el bucket '#{cfxm.bucket}' porque no existía."
    end
  rescue => e
    raise MinioConnectionError, "No se pudo conectar a Minio: #{e.message}"
  end

  def get(id)
    return nil if id.nil?

    obj = @bucket.object(id)

    unless obj.exists?
      return nil
    end

    SilverImage.new(
      id: obj.key,
      data: obj.get.body.read,
      nombre: obj.metadata['nombre'] || obj.key,
      content_type: obj.content_type
    )
  end

  def add(file)
    file_data = file.read
    obj = @bucket.object(SecureRandom.uuid)
    content_type = file.respond_to?(:content_type) ? file.content_type : "application/octet-stream"
    obj.put(
      body: file_data,
      content_type: content_type,
      metadata: { 'nombre' => file.original_filename }
    )

    SilverImage.new(
      id: obj.key,
      data: file_data,
      nombre: file.original_filename,
      content_type: content_type
    )
  end

  def remove!(record)
    @bucket.object(record.id.to_s).delete
  end

  # Used only by backup
  def all_ids
    @bucket.objects.map &:key
  end

  def clear_all!
    @bucket.objects.each do |obj|
      obj.delete
    end
  end

end
