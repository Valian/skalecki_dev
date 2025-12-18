# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :phoenix_vite, PhoenixVite.Npm,
  assets: [args: [], cd: Path.expand("../assets", __DIR__)],
  vite: [
    args: ~w(exec -- vite),
    cd: Path.expand("../assets", __DIR__),
    env: %{"MIX_BUILD_PATH" => Mix.Project.build_path()}
  ]

config :skalecki_dev,
  ecto_repos: [SkaleckiDev.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :skalecki_dev, SkaleckiDevWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: SkaleckiDevWeb.ErrorHTML, json: SkaleckiDevWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: SkaleckiDev.PubSub,
  live_view: [signing_salt: "xSW6LsB8"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :skalecki_dev, SkaleckiDev.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# PhoenixSrcset responsive image generation
config :phoenix_srcset,
  widths: [400, 800, 1200, 1600],
  format: "webp",
  quality: 85

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
