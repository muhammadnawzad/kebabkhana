Marten.configure :production do |config|
  # Application Settings
  config.host = "0.0.0.0"
  config.port = 3000
  onfig.secret_key = ENV.fetch("MARTEN_SECRET_KEY", "")
  config.allowed_hosts = ENV.fetch("MARTEN_ALLOWED_HOSTS", "").split(",")
  
  # Assets Settings
  config.assets.url = "/assets/"
  config.assets.dirs = [
    Path["src/assets/built"].expand,
    Path["src/assets/images"].expand,
  ]
  
  # Middlewares Settings
  config.middleware.unshift(Marten::Middleware::AssetServing)
  config.middleware.unshift(Marten::Middleware::SSLRedirect)

  # Emailing Settings
  config.emailing.from_address = "noreply@kebabkhana.com"
  config.emailing.backend = Marten::Emailing::Backend::Development.new(print_emails: true)

  # Database Settings
  if ENV.has_key?("DATABASE_URL")
    config.database do |db|
      database_uri = URI.parse(ENV.fetch("DATABASE_URL"))

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
