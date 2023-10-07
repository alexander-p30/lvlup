defmodule LVLUp.Repo do
  use Ecto.Repo,
    otp_app: :lvlup,
    adapter: Ecto.Adapters.Postgres
end
