# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :graphql,
  namespace: Graphql

# Configures the endpoint
config :graphql, GraphqlWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "qk02PkLMrzrsWreHGa5W0Q/0PutGWM/z915DOEqn/jlfoFHuBbmr6pDr+TeNJipZ",
  render_errors: [view: GraphqlWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Graphql.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
