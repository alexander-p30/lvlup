defmodule LVLUp.Scoring.Engines.GoodWorkChamp do
  @moduledoc """
  # TODO: add docs
  """

  alias LVLUp.Prompts.Prompt
  alias LVLUp.Scoring.Engine
  alias LVLUp.Scoring.EngineAnalysis.ScoreAnalysis
  alias LVLUp.Scoring.Score

  @behaviour Engine

  @impl true
  def analyse(%Prompt{} = prompt, skill_categories) when is_list(skill_categories) do
    score_analyses =
      Enum.map(skill_categories, fn skill_category ->
        score = %Score{
          skill_category_id: skill_category.id,
          prompt_id: prompt.id,
          number: Enum.random(3..5)
        }

        %ScoreAnalysis{score: score, metadata: %{}}
      end)

    {:ok, {score_analyses, %{}}}
  end
end
