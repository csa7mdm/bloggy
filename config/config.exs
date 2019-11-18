# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :bloggy,
  ecto_repos: [Bloggy.Repo]

# Configures the endpoint
config :bloggy, BloggyWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Gzemn2yniR+m/HULFoW5KyXVP/7HO2+33L1faEsZRee6rVjp+nHtCZ0VlP9snkQv",
  render_errors: [view: BloggyWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Bloggy.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :bloggy, BloggyWeb.Auth.Guardian,
  issuer: "bloggy",
  secret_key: "n7L51EYx1PS+xhh+nAeembdr2FH+bqk3JC5B/HeYcDlEbl//sJPhkU2LiBDr+/MS"
