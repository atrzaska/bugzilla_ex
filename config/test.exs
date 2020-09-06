use Mix.Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :bugzilla, BugzillaWeb.Endpoint,
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
