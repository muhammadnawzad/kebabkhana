Marten.configure :production do |config|
  # Application Settings
  config.host = "0.0.0.0"
  config.port = 3000
  config.secret_key = ENV.fetch("SELF__SECRET_KEY_BASE", "")
  config.allowed_hosts = ENV.fetch("SELF__ALLOWED_HOSTS", "").split(",")
  
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

  # Emailing Settings
  config.emailing.from_address = "noreply@kebabkhana.com"
  config.emailing.backend = Marten::Emailing::Backend::Development.new(print_emails: true)

  # Database Settings
  if ENV.has_key?("DATABASE__URL")
    config.database do |db|
      database_uri = URI.parse(ENV.fetch("DATABASE__URL"))

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
