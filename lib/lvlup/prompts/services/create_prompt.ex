defmodule LVLUp.Prompts.Services.CreatePrompt do
  @moduledoc """
  # TODO: add docs
  """

  alias LVLUp.Prompts.Prompt
  alias LVLUp.Prompts.Workers.ProcessPromptWorker
  alias LVLUp.Prompts
  alias LVLUp.Repo

  @doc @moduledoc
  @spec call(attrs :: map()) :: {:ok, Prompt.t()} | {:error, Ecto.Changeset.t()}
  def call(attrs) do
    Repo.transact(fn ->
      with {:ok, prompt} <- Prompts.create_prompt(attrs) do
        enqueue_score_job!(prompt)
        {:ok, Repo.preload(prompt, scores: :skill_category)}
      end
    end)
  end

  defp enqueue_score_job!(prompt),
    do: Oban.insert!(ProcessPromptWorker.new(%{prompt_id: prompt.id}))
end
