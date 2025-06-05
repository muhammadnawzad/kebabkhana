Marten.configure :production do |config|
  # Application Settings
  config.host = "0.0.0.0"
  config.port = 3000
  config.secret_key = ENV.fetch("KEBABKHANA__SELF__SECRET_KEY_BASE", "")
  config.allowed_hosts = ENV.fetch("KEBABKHANA__SELF__ALLOWED_HOSTS", "").split(",")
  
  # Assets Settings
  config.assets.url = "/assets/"
  config.assets.dirs = [
    Path["src/assets/built"].expand,
    Path["src/assets/images"].expand,
  ]

  # Allow origins
  config.csrf.trusted_origins = [
    "https://kebabkhana.online"
  ]
  
  # Middlewares Settings
  config.middleware.unshift(Marten::Middleware::AssetServing)
  
  # Database Settings
  if ENV.has_key?("KEBABKHANA__DATABASE__URL")
    config.database do |db|
      database_uri = URI.parse(ENV.fetch("KEBABKHANA__DATABASE__URL"))

      db.backend = :postgresql
      db.host = database_uri.host
      db.port = database_uri.port
      db.user = database_uri.user
      db.password = database_uri.password
      db.name = database_uri.path[1..]

      db.options = {"sslmode" => "disable"}
    end
  end
end
