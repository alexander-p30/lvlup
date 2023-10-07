defmodule Rpgdemo.Repo do
  use Ecto.Repo,
    otp_app: :rpgdemo,
    adapter: Ecto.Adapters.Postgres
end
