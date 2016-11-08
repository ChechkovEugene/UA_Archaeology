# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ua_archaeology,
  ecto_repos: [UaArchaeology.Repo]

# Configures the endpoint
config :ua_archaeology, UaArchaeology.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "xg/AHyHCyA+Or29+NMqoO65PQS/YE7aR48O6WQV0RHTcg3yEa/Wqak9USFeVIJYK",
  render_errors: [view: UaArchaeology.ErrorView, accepts: ~w(html json)],
  pubsub: [name: UaArchaeology.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
