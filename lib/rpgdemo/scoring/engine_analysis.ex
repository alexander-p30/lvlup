defmodule Rpgdemo.Scoring.EngineAnalysis do
  @moduledoc """
  # TODO: add docs
  """
  use TypedStruct

  alias Rpgdemo.Prompts.Prompt
  alias Rpgdemo.Scoring.Score

  typedstruct module: ScoreAnalysis do
    field :score, Score.t()
    field :metadata, map(), default: %{}
  end

  typedstruct do
    field :prompt, Prompt.t()
    field :engine, module()
    field :metadata, map(), default: %{}
    field :scores, [ScoreAnalysis.t()], default: []
  end
end
