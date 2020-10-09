defmodule Apperback.Repo do
  use Ecto.Repo,
    otp_app: :apperback,
    adapter: Ecto.Adapters.Postgres
end
