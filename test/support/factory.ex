defmodule LVLUp.Factory do
  # with Ecto
  use ExMachina.Ecto, repo: LVLUp.Repo

  alias LVLUp.Scoring.EngineAnalysis.ScoreAnalysis
  alias LVLUp.Prompts.Prompt
  alias LVLUp.Scoring.EngineAnalysis
  alias LVLUp.Scoring.Score
  alias LVLUp.Skills.SkillCategory

  def prompt_factory do
    %Prompt{text: Faker.Lorem.sentence(), status: :created}
  end

  def skill_category_factory do
    %SkillCategory{
      title: Faker.Superhero.power(),
      color: Faker.Color.rgb_hex(),
      description: Faker.Lorem.sentence(),
      status: :active
    }
  end

  def score_factory(attrs) do
    skill_category = Map.get_lazy(attrs, :skill_category, fn -> build(:skill_category) end)
    prompt = Map.get_lazy(attrs, :prompt, fn -> build(:prompt) end)

    score = %Score{
      number: Enum.random(0..5),
      skill_category: skill_category,
      skill_category_id: skill_category.id,
      prompt: prompt,
      prompt_id: prompt.id
    }

    merge_attributes(score, attrs)
  end

  def engine_analysis_factory(attrs) do
    score_analyses = Map.get_lazy(attrs, :score_analyses, fn -> build_pair(:score_analysis) end)
    prompt = Map.get_lazy(attrs, :prompt, fn -> build(:prompt) end)

    analysis = %EngineAnalysis{
      engine: LVLUp.Scoring.Engine,
      prompt: prompt,
      metadata: %{},
      score_analyses: score_analyses
    }

    merge_attributes(analysis, attrs)
  end

  def score_analysis_factory(attrs) do
    score = Map.get_lazy(attrs, :score, fn -> build(:score) end)
    analysis = %ScoreAnalysis{score: score, metadata: %{}}

    merge_attributes(analysis, attrs)
  end
end
