module Maintenance
  include UnlimitedCache

  KEY = "maintenance_mode"

  def with_maintenance
    cache_fetch(KEY){true}
    yield
  ensure
    cache_delete(KEY)
  end

  def maintenance_enabled?
    cache_fetch(KEY)
  end
end