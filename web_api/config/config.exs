# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :web_api,
  ecto_repos: [WebApi.Repo]

# Configures the endpoint
config :web_api, WebApi.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "X6u6ck8WG3PETFHj2BxXfDvNQSGtBmxn7qYV7uXol33tYhwNAskTdcnEan2+Fga0",
  render_errors: [view: WebApi.ErrorView, accepts: ~w(html json)],
  pubsub: [name: WebApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
