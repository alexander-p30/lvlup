defmodule LVLUpWeb.PromptLive.Index do
  use LVLUpWeb, :live_view

  alias LVLUp.Prompts
  alias LVLUp.Prompts.Prompt
  alias LVLUp.Prompts.PromptStatus

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> stream(:prompts, Prompts.list_prompts())
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
