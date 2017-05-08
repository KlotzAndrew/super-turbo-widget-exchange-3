# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :websocket_server, WebsocketServer.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "W44hubaOzVFIJfTF2+hVvEkBqFgeOCS7abQ+U82KSv0jZ6WEbxKCgISSK4U3IQ8Z",
  render_errors: [view: WebsocketServer.ErrorView, accepts: ~w(html json)],
  pubsub: [name: WebsocketServer.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
