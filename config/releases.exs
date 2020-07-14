
import Config

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :wasmdome, WasmdomeWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base

config :wasmdome, Wasmdome.Repo,
  database: System.fetch_env!("DB_NAME"),
  username: System.fetch_env!("DB_USER"),
  password: System.fetch_env!("DB_PASS"),
  hostname: System.fetch_env!("DB_HOST")

config :wasmdome,
  ecto_repos: [Wasmdome.Repo]

config :ueberauth, Ueberauth.Strategy.Auth0.OAuth,
  domain: System.fetch_env!("AUTH0_DOMAIN"),
  client_id: System.fetch_env!("AUTH0_CLIENT_ID"),
  client_secret: System.fetch_env!("AUTH0_CLIENT_SECRET")

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :wasmdome, WasmdomeWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
