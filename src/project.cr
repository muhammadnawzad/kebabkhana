# Third party requirements.
require "marten"
require "marten_auth"
require "pg"
require "dotenv"
require "debug"

# Configuration requirements.
require "../config/routes"
require "../config/settings/base"
require "../config/settings/**"
require "../config/initializers/**"

# Project requirements.
require "./apps/auth/app"
require "./apps/management/app"
require "./handlers/**"
require "./emails/**"
require "./models/**"
require "./schemas/**"
