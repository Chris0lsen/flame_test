import Config

config :logger, :console,
  format: "[$level] $message\n",
  metadata: [:module, :function]

config :logger, level: :debug
