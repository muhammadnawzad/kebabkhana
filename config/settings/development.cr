Marten.configure :development do |config|
  config.debug = true
  config.host = "localhost"
  config.port = 3000

  config.assets.url = "/assets/"
  config.assets.dirs = [
    Path["src/assets/built"].expand,
    Path["src/assets/images"].expand,
  ]
end
