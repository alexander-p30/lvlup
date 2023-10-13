defmodule LVLUp.Scoring do
  @moduledoc """
  # TODO: add docs
  """

  alias LVLUp.Prompts.Prompt
  alias LVLUp.Repo
  alias LVLUp.Scoring.Engine
  alias LVLUp.Scoring.EngineAnalysis
  alias LVLUp.Scoring.Score

  @spec compute_score(Prompt.t()) :: {:ok, EngineAnalysis.t()} | {:error, any()}
  def compute_score(%Prompt{} = prompt), do: Engine.analyse(prompt)

  def create_score(attrs) do
    %Score{}
    |> Score.changeset(attrs)
    |> Repo.insert()
  end
end
