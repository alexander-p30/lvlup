defmodule LVLUp.Scoring.Engine do
  @moduledoc """
  # TODO: add docs
  """

  alias LVLUp.Prompts.Prompt
  alias LVLUp.Scoring.EngineAnalysis

  @callback analyse(Prompt.t()) :: EngineAnalysis.t()

  @spec call(Prompt.t(), engine :: module()) :: {:ok, EngineAnalysis.t()} | {:error, any()}
  def call(%Prompt{} = prompt, engine \\ default_engine!()), do: engine.analyse(prompt)

  @spec default_engine! :: module()
  defp default_engine!, do: LVLUp.fetch_env!([__MODULE__, :default_engine])
end
