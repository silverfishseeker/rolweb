module Kernel
  def error_coalesce(*allowed_exceptions)
    begin
      yield || nil
    rescue NoMethodError 
      nil
    rescue => e
      raise e unless allowed_exceptions.include?(e.class)
      nil
    end
  end
end