defmodule LVLUp.Prompts.Services.UpdatePrompt do
  @moduledoc """
  # TODO: add docs
  """

  alias LVLUp.Prompts
  alias LVLUp.Prompts.Prompt
  alias LVLUp.Prompts.PromptStatus
  alias LVLUp.Prompts.Workers.ProcessPromptWorker
  alias LVLUp.Repo

  @doc @moduledoc
  @spec call(Prompt.t(), attrs :: map()) :: {:ok, Oban.Job.t()}
  def call(%Prompt{} = prompt, attrs) do
    Repo.transact(fn ->
      with changeset <- Prompts.change_prompt(prompt, attrs),
           {:ok, updated_prompt} <- Prompts.update_prompt(changeset) do
        if should_score_prompt?(changeset), do: insert_score_job(prompt.id)
        {:ok, updated_prompt}
      end
    end)
  end

  defp insert_score_job(prompt_id) do
    %{prompt_id: prompt_id}
    |> ProcessPromptWorker.new()
    |> Oban.insert()
  end

  defp should_score_prompt?(changeset) do
    text_changed? = Ecto.Changeset.changed?(changeset, :text)

    status_changed_to_processing? =
      Ecto.Changeset.get_change(changeset, :status) == PromptStatus.processing()

    text_changed? or status_changed_to_processing?
  end
end
