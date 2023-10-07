defmodule LVLUp.Scoring.Score do
  @moduledoc """
  # TODO: add docs
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias LVLUp.Prompts.Prompt
  alias LVLUp.Skills.SkillCategory

  @fields [:number, :prompt_id, :skill_category_id]

  @type t :: %__MODULE__{}

  schema "scores" do
    field :number, :integer

    belongs_to :prompt, Prompt
    belongs_to :skill_category, SkillCategory

    timestamps()
  end

  def changeset(prompt \\ %__MODULE__{}, attrs) do
    prompt
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> validate_number(:number, greater_than_or_equal_to: 0, less_than_or_equal_to: 5)
    |> assoc_constraint(:prompt)
    |> assoc_constraint(:skill_category)
  end
end
