Marten.configure do |config|
  # IMPORTANT: please ensure that the secret key value is kept secret!
  config.secret_key = "__insecure_d6c626abd975a5544f713ad0af727f77f75f4f7fcc02e2447f7a776d8b3bafc9__"

  # Installed applications
  # https://martenframework.com/docs/development/reference/settings#installed_apps
  config.installed_apps = [
    Auth::App,
  ]

  # Application middlewares
  # https://martenframework.com/docs/development/reference/settings#middleware
  config.middleware = [
    Marten::Middleware::Session,
    Marten::Middleware::Flash,
    MartenAuth::Middleware,
    Marten::Middleware::GZip,
    Marten::Middleware::XFrameOptions,
    Marten::Middleware::ReferrerPolicy,
  ]

  # Databases
  # https://martenframework.com/docs/development/reference/settings#database-settings
  config.database do |db| # ameba:disable Naming/BlockParameterName
    db.backend = :sqlite
    db.name = Path["kebabkhana.db"].expand
  end

  # Templates context producers
  # https://martenframework.com/docs/development/reference/settings#context_producers
  config.templates.context_producers = [
    Marten::Template::ContextProducer::Request,
    Marten::Template::ContextProducer::Flash,
    Marten::Template::ContextProducer::Debug,
    Marten::Template::ContextProducer::I18n,
  ]

  # Authentication model
  config.auth.user_model = Auth::User
end
