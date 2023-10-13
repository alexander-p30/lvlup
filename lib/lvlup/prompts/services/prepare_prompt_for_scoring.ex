defmodule LVLUp.Prompts.Services.PreparePromptForScoring do
  @moduledoc """
  # TODO: add docs
  """

  alias LVLUp.Prompts
  alias LVLUp.Prompts.Prompt
  alias LVLUp.Scoring.EngineAnalysis

  @doc @moduledoc
  @spec call(Prompt.t()) :: {:ok, EngineAnalysis.t()} | {:error, any()}
  def call(%Prompt{} = prompt) do
    LVLUp.Repo.transact(fn ->
      with {:ok, prompt} <- Prompts.update_prompt(prompt, %{status: :processing}) do
        {:ok, prompt}
      end
    end)
  end
end
