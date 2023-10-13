defmodule LVLUpWeb.PromptLive.FormComponent do
  use LVLUpWeb, :live_component

  alias LVLUp.Prompts
  alias LVLUp.Prompts.Services.CreatePrompt
  alias LVLUp.Prompts.Services.UpdatePrompt

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage prompt records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="prompt-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:text]} type="text" label="Text" />
        <.input field={@form[:status]} type="hidden" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Prompt</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{prompt: %{} = prompt} = assigns, socket) do
    changeset = Prompts.change_prompt(prompt)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"prompt" => prompt_params}, socket) do
    changeset =
      socket.assigns.prompt
      |> Prompts.change_prompt(prompt_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"prompt" => prompt_params}, socket) do
    {:noreply,
     socket
     |> save_prompt(socket.assigns.action, prompt_params)
     |> reset_input()}
  end

  defp reset_input(socket) do
    assign_form(socket, Ecto.Changeset.change(socket.assigns.prompt, %{}))
  end

  defp save_prompt(socket, :edit, prompt_params) do
    case UpdatePrompt.call(socket.assigns.prompt, prompt_params) do
      {:ok, prompt} ->
        notify_parent({:saved, prompt})

        socket
        |> put_flash(:info, "Prompt updated successfully")
        |> push_patch(to: socket.assigns.patch)

      {:error, %Ecto.Changeset{} = changeset} ->
        assign_form(socket, changeset)
    end
  end

  defp save_prompt(socket, :new, prompt_params) do
    case CreatePrompt.call(prompt_params) do
      {:ok, prompt} ->
        notify_parent({:saved, prompt})
        put_flash(socket, :info, "Prompt created successfully")

      {:error, %Ecto.Changeset{} = changeset} ->
        assign_form(socket, changeset)
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
