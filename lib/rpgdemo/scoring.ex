defmodule LVLUp.Scoring do
  @moduledoc """
  # TODO: add docs
  """

  alias LVLUp.Prompts.Prompt
  alias LVLUp.Repo
  alias LVLUp.Scoring.Engine
  alias LVLUp.Scoring.EngineAnalysis
  alias LVLUp.Scoring.Score

  @engine_mapping %{
    chatgpt_3_5: LVLUp.Scoring.Engines.ChatGPT_3_5
  }

  @spec compute_score(Prompt.t()) :: {:ok, EngineAnalysis.t()} | {:error, any()}
  def compute_score(%Prompt{} = prompt), do: Engine.call(prompt)

  def create_score(attrs) do
    %Score{}
    |> Score.changeset(attrs)
    |> Repo.insert()
  end

  # defp fetch_engine!(engine), do: Map.fetch!(@engine_mapping, engine)
end
