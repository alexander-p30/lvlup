defmodule Rpgdemo.Skills.SkillCategory do
  @moduledoc """
  # TODO: add docs
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Rpgdemo.Skills.SkillCategoryStatus

  @fields [:title, :color, :description, :status]
  @six_digit_hex_color ~R/^#([A-F0-9]{6})$/

  schema "skill_categories" do
    field :title, :string
    field :color, :string
    field :description, :string
    field :status, Ecto.Enum, values: SkillCategoryStatus.values()

    timestamps()
  end

  def changeset(skill_category \\ %__MODULE__{}, attrs) do
    skill_category
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> validate_inclusion(:status, SkillCategoryStatus.values())
    |> validate_format(:color, @six_digit_hex_color,
      message: "must be a valid 6-digit HEX color code starting with #"
    )
    |> unique_constraint(:title)
    |> unique_constraint(:color)
  end
end
