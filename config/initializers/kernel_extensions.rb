module Kernel
  def error_coalesce 
    begin
      yield || nil
    rescue NoMethodError 
      nil
    end
  end
end