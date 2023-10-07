defmodule Rpgdemo.Prompts.Prompt do
  @moduledoc """
  # TODO: add docs
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Rpgdemo.Prompts.PromptStatus
  alias Rpgdemo.Scoring.Score
  alias Rpgdemo.Skills.SkillCategoryStatus

  @type t :: %__MODULE__{}

  @fields [:text, :status]

  schema "prompts" do
    field :text, :string
    field :status, Ecto.Enum, values: PromptStatus.values()

    has_many :scores, Score

    has_many :skill_categories,
      through: [:scores, :skill_category],
      where: [status: SkillCategoryStatus.active()]

    timestamps()
  end

  @doc false
  def changeset(prompt, attrs) do
    prompt
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> validate_inclusion(:status, PromptStatus.values())
  end
end
