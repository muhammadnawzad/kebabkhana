Marten.configure :production do |config|
  config.port = 3000
  config.assets.url = "/assets/"
  config.assets.dirs = [
    Path["src/assets/built"].expand,
    Path["src/assets/images"].expand,
  ]
  config.allowed_hosts = ENV.fetch("SELF__ALLOWED_HOSTS", "").split(",")
  config.middleware.unshift(Marten::Middleware::AssetServing)
  config.emailing.from_address = "noreply@kebabkhana.com"
  config.emailing.backend = Marten::Emailing::Backend::Development.new(print_emails: true)
end
