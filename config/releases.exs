import Config

config :bugzilla, BugzillaWeb.Endpoint,
  url: [
    host: System.get_env("APP_HOST") || "localhost",
    scheme: System.get_env("APP_SCHEME") || "http",
    port: String.to_integer(System.get_env("APP_PORT") || "80")
  ],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  live_view: [signing_salt: System.get_env("SECRET_SALT")]

config :bugzilla, Bugzilla.Repo,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE"))

config :sentry,
  dsn: System.get_env("SENTRY_DSN"),
  environment_name: :prod,
  enable_source_code_context: true,
  root_source_code_path: File.cwd!(),
  tags: %{env: "production"},
  included_environments: [:prod]

config :bugzilla, Bugzilla.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: System.get_env("SMTP_HOST"),
  hostname: System.get_env("APP_HOST"),
  port: String.to_integer(System.get_env("SMTP_PORT")),
  username: System.get_env("SMTP_USER"),
  password: System.get_env("SMTP_PASSWORD")
