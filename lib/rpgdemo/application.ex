defmodule LVLUp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      LVLUpWeb.Telemetry,
      # Start the Ecto repository
      LVLUp.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: LVLUp.PubSub},
      # Start Finch
      {Finch, name: LVLUp.Finch},
      # Start the Endpoint (http/https)
      LVLUpWeb.Endpoint
      # Start a worker by calling: LVLUp.Worker.start_link(arg)
      # {LVLUp.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LVLUp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LVLUpWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
