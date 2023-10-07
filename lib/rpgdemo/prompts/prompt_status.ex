defmodule Rpgdemo.Prompts.PromptStatus do
  @moduledoc """
  # TODO: add docs
  """

  def values, do: [created(), processed(), archived()]
  def created, do: :created
  def processed, do: :processed
  def archived, do: :archived
end
