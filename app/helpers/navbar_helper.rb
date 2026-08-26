module NavbarHelper
  include UnlimitedCache

  def navbar_cache_clases_ocultas
    cache_fetch "clases_ocultas" do
      Clase.where(oculto: true).order(:nombre).to_a
    end
  end

  def navbar_cache_clases_visibles
    cache_fetch "clases_visibles" do
      Clase.where(oculto: false).order(:nombre).to_a
    end
  end

  def navbar_cache_categorias
    cache_fetch "categorias" do
      Categ.order(:nombre).to_a
    end
  end

  ENCYCLOPEDIA_MENU_MAX_DEPTH = 3

  def navbar_cache_encyclopedia_tree
    return if ! cuento_main ||= Cuento.order(prioridad: :desc).first
    cache_fetch "encyclopedia_tree" do
      root = {
        cuento: cuento_main,
        depth: 0
      }
      opened_nodes = [root]
      while opened_nodes.any? do
        node = opened_nodes.pop
        child_nodes = node[:cuento].childs.where(oculto: false)
            .order(nombre: :asc).map do |child|
          {
            cuento: child,
            depth: node[:depth] + 1
          }
        end
        node[:childs] = child_nodes
        opened_nodes += child_nodes if node[:depth] < ENCYCLOPEDIA_MENU_MAX_DEPTH
      end
      root
    end
  end
end
