defmodule LVLUp.Prompts.PromptStatus do
  @moduledoc """
  # TODO: add docs
  """

  def values, do: [created(), processing(), processed(), archived()]
  def created, do: :created
  def processing, do: :processing
  def processed, do: :processed
  def archived, do: :archived
end
