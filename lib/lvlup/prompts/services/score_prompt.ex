defmodule LVLUp.Prompts.Services.ScorePrompt do
  @moduledoc """
  # TODO: add docs
  """

  alias LVLUp.Skills.SkillCategory
  alias LVLUp.Prompts
  alias LVLUp.Prompts.Prompt
  alias LVLUp.Repo
  alias LVLUp.Scoring.Engine
  alias LVLUp.Scoring.EngineAnalysis
  alias LVLUp.Scoring.EngineAnalysis.ScoreAnalysis
  alias LVLUp.Scoring.Score

  @prompt_scored_topic "prompt.scored"

  @doc @moduledoc
  @spec call(Prompt.t()) :: {:ok, EngineAnalysis.t()} | {:error, any()}
  def call(%Prompt{} = prompt) do
    Repo.transact(fn ->
      with {:ok, analysis} <- Engine.analyse(prompt, skill_categories: Repo.all(SkillCategory)),
           delete_current_scores(prompt),
           scores = insert_scores(analysis.score_analyses),
           {:ok, _prompt} <- Prompts.update_prompt(prompt, %{status: :processed}),
           notify_prompt_scored(prompt) do
        scores = Enum.sort_by(scores, & &1.skill_category_id)
        score_analyses = Enum.sort_by(analysis.score_analyses, & &1.score.skill_category_id)

        {:ok,
         %EngineAnalysis{
           analysis
           | score_analyses: update_score_analyses_with_inserted_scores(score_analyses, scores)
         }}
      end
    end)
  end

  defp delete_current_scores(prompt) do
    %{scores: scores} = Repo.preload(prompt, :scores)
    Enum.each(scores, &Repo.delete/1)
  end

  defp insert_scores(score_analyses) when is_list(score_analyses) do
    scores = Enum.map(score_analyses, &build_score_attrs(&1.score))
    {_, scores} = Repo.insert_all(Score, scores, returning: true)
    scores
  end

  defp build_score_attrs(%Score{} = score) do
    score
    |> Map.take([:number, :prompt_id, :skill_category_id])
    |> Map.update!(:prompt_id, fn prompt_id -> prompt_id || score.prompt.id end)
    |> Map.update!(:skill_category_id, fn skill_category_id -> skill_category_id || score.skill_category.id end)
    |> Map.merge(timestamps())
  end

  defp update_score_analyses_with_inserted_scores(score_analyses, inserted_scores) do
    score_analyses
    |> Enum.zip(inserted_scores)
    |> Enum.map(fn {score_analysis, score} ->
      %ScoreAnalysis{score_analysis | score: score}
    end)
  end

  defp timestamps do
    now = NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
    %{inserted_at: now, updated_at: now}
  end

  defp notify_prompt_scored(prompt), do: LVLUpWeb.Endpoint.broadcast!(@prompt_scored_topic, "prompt_scored", prompt.id)
end
