module NavbarHelper
  include UnlimitedCache

  ENCYCLOPEDIA_MENU_MAX_DEPTH = 3

  def navbar_cache_encyclopedia_tree
    return if ! cuento_main ||= Cuento.order(prioridad: :desc).first
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
