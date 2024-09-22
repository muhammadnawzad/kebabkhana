# Third party requirements.
require "marten"
require "marten_auth"
require "sqlite3"

# Configuration requirements.
require "../config/settings/base"
require "../config/settings/**"
require "../config/initializers/**"
require "../config/routes"

# Project requirements.
require "./apps/auth/app"
require "./emails/**"
require "./handlers/**"
require "./models/**"
require "./schemas/**"
