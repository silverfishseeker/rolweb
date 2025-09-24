Rails.application.config.after_initialize do
  begin
    context = ActiveRecord::Base.connection.migration_context

    if context.needs_migration?
      context.migrate
      Rails.logger.info "initializers/data.rb: Migrated."
    else
      Rails.logger.info "initializers/data.rb: No sé migró."
    end


  rescue ActiveRecord::NoDatabaseError
    Rails.logger.error "initializers/data.rb: no se pudo acceder a la base de datos."
  end
end