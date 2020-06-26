defmodule Api.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Api.Repo,
      # Start the endpoint when the application starts
      {Phoenix.PubSub, name: Api.PubSub},
      ApiWeb.Endpoint,
      # Api.Nationbuilder.ServicesSupervisor
      # Starts a worker by calling: Api.Worker.start_link(arg)
      # {Api.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Api.Supervisor]

    supervised_app = Supervisor.start_link(children, opts)

    # Api.Nationbuilder.ServicesSupervisor.start_workers_for_active_organizations()

    supervised_app
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
