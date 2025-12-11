module Kernel
  def error_coalesce(*allowed_exceptions, default:nil)
    yield || default
  rescue NoMethodError 
    default
  rescue => e
    raise e unless allowed_exceptions.include?(e.class)
    default
  end
end