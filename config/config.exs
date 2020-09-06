# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :bugzilla,
  ecto_repos: [Bugzilla.Repo]

config :bugzilla, Bugzilla.Repo,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

# Configures the endpoint
config :bugzilla, BugzillaWeb.Endpoint,
  url: [
    host: System.get_env("APP_HOST") || "localhost",
    scheme: System.get_env("APP_SCHEME") || "http",
    port: String.to_integer(System.get_env("APP_PORT") || "80")
  ],
  http: [port: 4000, transport_options: [socket_opts: [:inet6]]],
  secret_key_base: System.get_env("SECRET_KEY_BASE") || "1",
  live_view: [signing_salt: System.get_env("SECRET_SALT") || "1"],
  render_errors: [view: BugzillaWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Bugzilla.PubSub,

# Configures Elixir's Logger
config :logger,
  backends: [:console, Sentry.LoggerBackend]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# slim engine
config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine

# Bamboo
config :bugzilla, Bugzilla.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: System.get_env("SMTP_HOST") || "localhost",
  hostname: System.get_env("APP_HOST") || "localhost",
  port: String.to_integer(System.get_env("SMTP_PORT") || "1080")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
