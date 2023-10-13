defmodule LVLUp.Prompts.Workers.ProcessPromptWorker do
  @moduledoc """
  # TODO: add docs
  """
  alias LVLUp.Prompts.Services.PreparePromptForScoring
  use Oban.Worker

  alias LVLUp.Prompts
  alias LVLUp.Prompts.Services.ScorePrompt

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"prompt_id" => prompt_id}}) do
    with {:ok, prompt} <- fetch_prompt(prompt_id),
         {:ok, prompt} <- PreparePromptForScoring.call(prompt) do
      ScorePrompt.call(prompt)
    end
  end

  defp fetch_prompt(id) do
    case Prompts.get_prompt(id) do
      nil -> {:cancel, {:not_found, "Prompt not found"}}
      prompt -> {:ok, prompt}
    end
  end
end
