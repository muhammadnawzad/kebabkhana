Marten.configure :development do |config|
  config.debug = true
  config.host = "localhost"
  config.port = 3000

  # Print sent emails to the standard output in development.
  # https://martenframework.com/docs/development/reference/settings#emailing-settings
  config.emailing.backend = Marten::Emailing::Backend::Development.new(print_emails: true)
end
