defmodule LVLUp.PromptsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LVLUp.Prompts` context.
  """

  @doc """
  Generate a prompt.
  """

  def prompt_fixture(attrs \\ %{}) do
    {:ok, prompt} =
      attrs
      |> Enum.into(%{text: "some text", status: :created})
      |> LVLUp.Prompts.create_prompt()

    prompt
  end
end
