defmodule LVLUp.Scoring.Engine do
  @moduledoc """
  # TODO: add docs
  """

  alias LVLUp.Prompts.Prompt
  alias LVLUp.Repo
  alias LVLUp.Scoring.EngineAnalysis
  alias LVLUp.Skills.SkillCategory

  @callback analyse(Prompt.t(), [SkillCategory.t()]) ::
              {:ok, {[EngineAnalysis.ScoreAnalysis.t()], engine_metadata :: map()}}
              | {:error, any()}

  @spec analyse(Prompt.t(), opts :: Keyword.t()) :: {:ok, EngineAnalysis.t()} | {:error, any()}
  def analyse(%Prompt{} = prompt, opts \\ []) do
    skill_categories = Keyword.get_lazy(opts, :skill_categories, fn -> Repo.all(SkillCategory) end)
    engine = Keyword.get_lazy(opts, :engine, fn -> default_engine!() end)
    analysis = %EngineAnalysis{prompt: prompt, engine: engine}

    with {:ok, {score_analyses, engine_metadata}} <- engine.analyse(prompt, skill_categories) do
      {:ok, %EngineAnalysis{analysis | score_analyses: score_analyses, metadata: engine_metadata}}
    end
  end

  @spec default_engine! :: module()
  defp default_engine!, do: LVLUp.fetch_env!([__MODULE__, :default_engine])
end
