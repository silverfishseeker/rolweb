module ApplicationHelper

  def main_cuento_path
    cache_fetch "cuento_first" do
      cuento = Cuento.order(prioridad: :desc).first
      cuento.present? ? cuento_path(cuento) : "#"
    end
  end

  def importJS (*module_names)
    module_names.each do |module_name|
      content_for :page_js do
        concat content_tag(:div, "", data: { js: module_name })
      end
    end
  end

  def only_admin_content
    if session[:admin]
      yield
    end
  end

  def not_admin_content
    unless session[:admin]
      yield
    end
  end
  
  def compose_get_params(hash)
    "?" + hash.map { |k, v| "#{k}=#{v}" }.join("&")
  end
end
