require "./filters/**"
require "./handlers/**"
require "./models/**"
require "./routes"
require "./schemas/**"

module Management
  class App < Marten::App
    label :management
  end
end
