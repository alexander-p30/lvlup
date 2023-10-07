defmodule Rpgdemo do
  @moduledoc """
  Rpgdemo keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @spec fetch_env!([atom()]) :: any()
  def fetch_env!([first_key | path]) do
    Enum.reduce(path, Application.fetch_env!(:rpgdemo, first_key), fn key, env ->
      Keyword.fetch!(key, env)
    end)
  end
end
