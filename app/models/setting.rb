class Setting < RailsSettings::Base
  cache_prefix { "v1" }

  field :site_title,  default: "Web Application"
  field :admin_email, default: "admin@example.com"
end
