# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :takeaplege_api,
  ecto_repos: [TakeaplegeApi.Repo]

# Configures the endpoint
config :takeaplege_api, TakeaplegeApi.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+RiJiXYW3XyxN3UOWQxSF/128omAllLRl/6aK4f5gfOW46IiADtT9uZezVjUxItT",
  render_errors: [view: TakeaplegeApi.Web.ErrorView, accepts: ~w(json)],
  pubsub: [name: TakeaplegeApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
