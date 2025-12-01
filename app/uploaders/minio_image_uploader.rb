require "aws-sdk-s3"
require "securerandom"

class MinioConnectionError < StandardError; end

class MinioImageUploader

  def initialize
    s3_resource = Aws::S3::Resource.new(
      endpoint: EnvVars["MINIO_ENDPOINT"],
      access_key_id: EnvVars["MINIO_ACCESS_KEY_ID"],
      secret_access_key: EnvVars["MINIO_SECRET_ACCESS_KEY"],
      region: EnvVars["MINIO_REGION"],
      force_path_style: true
    )
    bucket_name = EnvVars["MINIO_BUCKET"]
    @bucket = s3_resource.bucket(bucket_name)

    unless @bucket.exists?
      begin
        s3_resource.create_bucket(bucket: bucket_name)
      rescue => e
        raise MinioConnectionError, "No se pudo crear el bucket '#{bucket_name}': #{e.message}"
      end
      Rails.logger.warn "Se ha creado el bucket '#{bucket_name}' porque no existía."
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
