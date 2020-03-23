# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :wasmdome, Wasmdome.Repo,
  database: System.get_env("DB_NAME","wasmdome"),
  username: System.get_env("DB_USER", "wasmdome"),
  password: System.get_env("DB_PASS", "wasmdome"),
  hostname: System.get_env("DB_HOST", "wopr")

config :wasmdome,
  ecto_repos: [Wasmdome.Repo]


# Configures the endpoint
config :wasmdome, WasmdomeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "aY2Ox/he8AyPnFQattYyvC7aPZ3BohhcVR7zp3KEkfpnoG+I5SrRXxMYGd3uFCHe",
  render_errors: [view: WasmdomeWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Wasmdome.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "Z2+kZugq"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures Ueberauth
config :ueberauth, Ueberauth,
  providers: [
    auth0: { Ueberauth.Strategy.Auth0, [] },
  ]

# Configures Ueberauth's Auth0 auth provider
config :ueberauth, Ueberauth.Strategy.Auth0.OAuth,
  domain: System.get_env("AUTH0_DOMAIN"),
  client_id: System.get_env("AUTH0_CLIENT_ID"),
  client_secret: System.get_env("AUTH0_CLIENT_SECRET")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
