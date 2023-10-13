defmodule LVLUpWeb.PromptLive.Index do
  use LVLUpWeb, :live_view

  alias LVLUp.Prompts
  alias LVLUp.Prompts.Prompt
  alias LVLUp.Prompts.PromptStatus

  @prompt_scored_topic "prompt.scored"

  @impl true
  def mount(_params, _session, socket) do
    LVLUpWeb.Endpoint.subscribe(@prompt_scored_topic)

    {:ok,
     socket
     |> stream(
       :prompts,
       Enum.sort_by(Prompts.list_prompts(scores: :skill_category), & &1.inserted_at, {:desc, NaiveDateTime})
     )
     |> assign(:prompt, new_prompt())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Prompt")
    |> assign(:prompt, Prompts.get_prompt!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Prompt")
    |> assign(:prompt, new_prompt())
  end

  defp apply_action(socket, :index, _params) do
    assign(socket, :page_title, "Listing Prompts")
  end

  @impl true
  def handle_info({LVLUpWeb.PromptLive.FormComponent, {:saved, prompt}}, socket) do
    {:noreply, stream_insert(socket, :prompts, prompt, at: 0)}
  end

  @impl true
  def handle_info(
        %Phoenix.Socket.Broadcast{topic: @prompt_scored_topic, event: "prompt_scored", payload: prompt_id},
        socket
      ) do
    prompt = Prompts.get_prompt!(prompt_id, scores: :skill_category)
    {:noreply, stream_insert(socket, :prompts, prompt)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    prompt = Prompts.get_prompt!(id)
    {:ok, _} = Prompts.delete_prompt(prompt)

    {:noreply, stream_delete(socket, :prompts, prompt)}
  end

  defp new_prompt, do: %Prompt{status: PromptStatus.created()}

  defp human_prompt_status(%Prompt{status: status}), do: human_prompt_status(status)
  defp human_prompt_status(status), do: status |> Atom.to_string() |> String.upcase()
end
