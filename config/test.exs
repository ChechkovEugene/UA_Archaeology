use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ua_archaeology, UaArchaeology.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :ua_archaeology, UaArchaeology.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "ua_archaeology_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  extensions: [{Geo.PostGIS.Extension, library: Geo}]

config :comeonin, bcrypt_log_rounds: 4
