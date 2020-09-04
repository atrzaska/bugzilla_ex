# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :bugzilla,
  ecto_repos: [Bugzilla.Repo]

# Configures the endpoint
config :bugzilla, BugzillaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  render_errors: [view: BugzillaWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Bugzilla.PubSub,
  live_view: [signing_salt: System.get_env("SECRET_SALT")]

# Configures Elixir's Logger
config :logger,
  backends: [:console, Sentry.LoggerBackend]

config :sentry,
  dsn: System.get_env("SENTRY_DSN"),
  environment_name: Mix.env(),
  included_environments: [:prod],
  enable_source_code_context: true,
  root_source_code_path: File.cwd!()

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
  server: "localhost",
  hostname: "bugzilla.app",
  port: 1025

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
