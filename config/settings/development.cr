Marten.configure :development do |config|
  config.debug = true
  config.host = "localhost"
  config.port = 3000

  # Print sent emails to the standard output in development.
  # https://martenframework.com/docs/development/reference/settings#emailing-settings
  config.emailing.backend = Marten::Emailing::Backend::Development.new(print_emails: true)

  config.assets.url = "/assets/"
  config.assets.dirs = [
    Path["src/assets/built"].expand,
    Path["src/assets/images"].expand,
  ]

  webpack_sock = Socket.tcp(Socket::Family::INET)
  begin
    webpack_sock.bind("localhost", 3000)
  rescue Socket::BindError
    config.assets.url = "http://localhost:3000/assets/"
  end
  webpack_sock.close
end
