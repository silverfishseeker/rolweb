module ApplicationHelper

  def main_cuento_path
    cache_fetch "cuento_first" do
      cuento = Cuento.order(prioridad: :desc).first
      cuento.present? ? cuento_path(cuento) : "#"
    end
  end

  def importJS (*module_names)
    module_names.map do |module_name|
      concat(content_tag(:div, "", data: { js: module_name }))
    end.join("\n").html_safe
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
  
end
