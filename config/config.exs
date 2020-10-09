# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :apperback,
  ecto_repos: [Apperback.Repo]

# Configures the endpoint
config :apperback, ApperbackWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "JZBtfTqgMcK1yW4REdIiLgms2HN3CVaXpV+xjcQWW3+alnvqNm6C2jXfaz+WMTjE",
  render_errors: [view: ApperbackWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Apperback.PubSub,
  live_view: [signing_salt: "GTAkoCb9"]

config :apperback,
  mongo_url: System.get_env("MONGO_URL"),
  mongo_username: System.get_env("MONGO_USERNAME"),
  mongo_password: System.get_env("MONGO_PASSWORD"),
  mongo_host: System.get_env("MONGO_HOST"),
  mongo_database: "apperback_dev"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
