defmodule SkaleckiDev.Repo do
  use Ecto.Repo,
    otp_app: :skalecki_dev,
    adapter: Ecto.Adapters.SQLite3
end
