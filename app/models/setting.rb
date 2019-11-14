class Setting < RailsSettings::Base
  cache_prefix { "v1" }

  field :site_title,  default: "Siderail"
  field :admin_email, default: "admin@example.com"
end
