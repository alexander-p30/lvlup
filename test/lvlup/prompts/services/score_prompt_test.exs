defmodule LVLUp.Prompts.Services.ScorePromptTest do
  use LVLUp.DataCase, async: true

  import Mox

  alias LVLUp.Prompts.Services.ScorePrompt
  alias LVLUp.Scoring.EngineAnalysis

  setup :verify_on_exit!

  setup do
    %{skill_categories: insert_pair(:skill_category), prompt: insert(:prompt)}
  end

  test "call engine to score prompt", ctx do
    scores = build_scores(ctx.prompt, ctx.skill_categories, [0, 4])

    expect(LVLUp.Scoring.Engines.EngineMock, :analyse, fn analysed_prompt, categories ->
      assert analysed_prompt == ctx.prompt
      assert_lists_equal(categories, ctx.skill_categories)

      score_analyses = Enum.map(scores, &build(:score_analysis, score: &1))
      {:ok, {score_analyses, %{mock: true}}}
    end)

    assert {:ok, engine_analysis} = ScorePrompt.call(ctx.prompt)

    assert %EngineAnalysis{
             engine: LVLUp.Scoring.Engines.EngineMock,
             metadata: %{mock: true},
             score_analyses: score_analyses
           } = engine_analysis

    assert_lists_equal(scores, Enum.map(score_analyses, & &1.score), &compare_scores/2)
  end

  test "delete existing scores and create new ones", ctx do
    old_scores =
      ctx.skill_categories
      |> Enum.zip([1, 3])
      |> Enum.map(fn {category, number} ->
        insert(:score, skill_category: category, number: number, prompt: ctx.prompt)
      end)

    new_scores = build_scores(ctx.prompt, ctx.skill_categories, [0, 4])

    expect(LVLUp.Scoring.Engines.EngineMock, :analyse, fn analysed_prompt, categories ->
      assert analysed_prompt == ctx.prompt
      assert_lists_equal(categories, ctx.skill_categories)

      score_analyses = Enum.map(new_scores, &build(:score_analysis, score: &1))
      {:ok, {score_analyses, %{mock: true}}}
    end)

    assert {:ok, engine_analysis} = ScorePrompt.call(ctx.prompt)

    assert %EngineAnalysis{
             engine: LVLUp.Scoring.Engines.EngineMock,
             metadata: %{mock: true},
             score_analyses: score_analyses
           } = engine_analysis

    assert_lists_equal(new_scores, Enum.map(score_analyses, & &1.score), &compare_scores/2)

    assert Enum.all?(old_scores, fn score -> is_nil(Repo.reload(score)) end)
    assert_lists_equal(new_scores, Repo.preload(ctx.prompt, :scores, force: true).scores, &compare_scores/2)
  end

  defp compare_scores(score_a, score_b) do
    keys = [:number, :skill_category_id, :prompt_id]

    Map.take(score_a, keys) == Map.take(score_b, keys)
  end

  defp build_scores(prompt, skill_categories, score_numbers) do
    skill_categories
    |> Enum.zip(score_numbers)
    |> Enum.map(fn {category, number} ->
      build(:score, skill_category: category, number: number, prompt: prompt)
    end)
  end
end
