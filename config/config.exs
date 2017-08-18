# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :timerobot,
  ecto_repos: [Timerobot.Repo]

# Configures the endpoint
config :timerobot, Timerobot.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "PkodHnCz6mg1mhJMlXq1rnKR6a4P+MgZRqVvH/4LXXCeT0tI8FFqbqTi3YmD1rRX",
  render_errors: [view: Timerobot.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Timerobot.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  issuer: "Timerobot.#{Mix.env}",
  ttl: {30, :days},
  verify_issuer: true,
  serializer: Timerobot.GuardianSerializer,
  secret_key: to_string(Mix.env) <> "QBwlWJJH5a3ZjywH8vlBjfL7pwJl2IhiXUeBHcC3DL/msE5udhhBcIqInBEJaHMU"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
