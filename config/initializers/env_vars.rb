if Rails.env.production?
  EnvVars.check_prodution_vars!
end
