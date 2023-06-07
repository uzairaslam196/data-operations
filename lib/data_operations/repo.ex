defmodule DataOperations.Repo do
  use Ecto.Repo,
    otp_app: :data_operations,
    adapter: Ecto.Adapters.Postgres
end
