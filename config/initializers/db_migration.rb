Rails.application.config.after_initialize do
  if ! ENV["MIGRATE_ON_INIT"]
    Rails.logger.info "initializers/db_migration.rb: won't try"
    next
  end
  context = ActiveRecord::Base.connection.migration_context

  if context.needs_migration?
    context.migrate
    Rails.logger.info "initializers/db_migration.rb: Migrated."
  else
    Rails.logger.info "initializers/db_migration.rb: Not migrated."
  end
end