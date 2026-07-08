xml.instruct!

excluded_controllers = [ AdminsessionsController].freeze
excluded_actions = [:new, :create, :edit, :update, :destroy].freeze

xml.urlset xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9" do

  add = -> (url, lastmod = nil) do # Usamos lambda para conservar la variable xml
    xml.url do
      xml.loc url
      xml.lastmod(lastmod.to_date.iso8601) if lastmod
    end
  end

  cache = {}

  Rails.application.routes.routes.each do |route|
    next unless route.verb == "GET"

    controller = "#{route.defaults[:controller].camelize}Controller".safe_constantize
    next unless controller
    next if excluded_controllers.include?(controller)

    action = route.defaults[:action]
    next unless AccessControl.public_action?(controller, action)
    next if excluded_actions.include?(action.to_sym)

    helper = route.name
    next if helper.blank?

    begin
      if controller < ModelController && route.required_parts == [:id]
        (cache[controller] ||= controller.new.tipo).find_each do |record|
          add.call(
            public_send("#{helper}_url", record),
            record.try(:updated_at) || record.try(:created_at)
          )
        end
      else
        add.call(public_send("#{helper}_url"))
      end
    rescue ArgumentError  # Ignorar rutas que no se pueden generar
    end
  end
end