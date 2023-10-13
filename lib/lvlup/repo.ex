defmodule LVLUp.Repo do
  use Ecto.Repo,
    otp_app: :lvlup,
    adapter: Ecto.Adapters.Postgres

  @doc """
  A wrapper for transactions, expects a function that returns one of the formats below:
    - {:ok, value}
    - :ok
    - {:error, reason}
    - :error
  """
  @spec transact((-> :ok | {:ok, any()} | {:error, any()} | :error), opts :: Keyword.t()) ::
          {:ok, any()} | {:error, any()}
  def transact(fun, opts \\ []) do
    transaction(
      fn ->
        case fun.() do
          {:ok, value} -> value
          :ok -> :ok
          {:error, reason} -> rollback(reason)
          :error -> rollback(:transaction_rollback_error)
        end
      end,
      opts
    )
  end
end
