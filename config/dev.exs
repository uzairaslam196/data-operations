import Config

# Configure your database
config :data_operations, DataOperations.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "data_operations_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"
