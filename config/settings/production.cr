Marten.configure :production do |config|
  # Application Settings
  config.host = "0.0.0.0"
  config.port = 3000
  config.allowed_hosts = ENV.fetch("SELF__ALLOWED_HOSTS", "").split(",")
  
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
end
