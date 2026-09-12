module ApplicationHelper

  def importJS (*module_names)
    module_names.each do |module_name|
      content_for :page_js do
        concat content_tag(:div, "", data: { js: module_name })
      end
    end
  end

  def only_admin_content
    yield if controller.has_level? :admin
  end
end
