# Third party requirements.
require "marten"
require "marten_auth"
require "pg"

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

# Dependencies.
require "dotenv"
require "./apps/kebab/app"
