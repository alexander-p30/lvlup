defmodule Rpgdemo.Skills.SkillCategoryStatus do
  @moduledoc """
  # TODO: add docs
  """

  def archived, do: :archived
  def active, do: :active
  def values, do: [active(), archived()]
end
