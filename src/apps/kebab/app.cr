require "./emails/**"
require "./handlers/**"
require "./models/**"
require "./routes"
require "./schemas/**"

module Kebab
  class App < Marten::App
    label "kebab"
  end
end
