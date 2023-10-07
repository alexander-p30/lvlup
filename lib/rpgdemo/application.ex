defmodule Rpgdemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      RpgdemoWeb.Telemetry,
      # Start the Ecto repository
      Rpgdemo.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Rpgdemo.PubSub},
      # Start Finch
      {Finch, name: Rpgdemo.Finch},
      # Start the Endpoint (http/https)
      RpgdemoWeb.Endpoint
      # Start a worker by calling: Rpgdemo.Worker.start_link(arg)
      # {Rpgdemo.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Rpgdemo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RpgdemoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
