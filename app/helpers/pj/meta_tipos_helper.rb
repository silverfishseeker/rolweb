module Pj::MetaTiposHelper
  def pj_meta_tipos_path_for(tipo_clase, **options)
    send("pj_#{Pj::MetaTipo::STR_STR[tipo_clase]}s_path", options)
  end

  def pj_meta_tipo_path(meta_tipo, **options)
    send("pj_#{Pj::MetaTipo.tipo_str(meta_tipo)}_path", meta_tipo, options)
  end

  def edit_pj_meta_tipo_path(meta_tipo, **options)
    send("edit_pj_#{Pj::MetaTipo.tipo_str(meta_tipo)}_path", meta_tipo, options)
  end

  def new_pj_meta_tipo_path_for(tipo_clase, **options)
    send("new_pj_#{Pj::MetaTipo.str_str(tipo_clase)}_path", options)
  end
end
