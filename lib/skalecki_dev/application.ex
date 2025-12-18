defmodule SkaleckiDev.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      [
        SkaleckiDevWeb.Telemetry,
        {DNSCluster, query: Application.get_env(:skalecki_dev, :dns_cluster_query) || :ignore},
        {Phoenix.PubSub, name: SkaleckiDev.PubSub},
        # Start a worker by calling: SkaleckiDev.Worker.start_link(arg)
        # {SkaleckiDev.Worker, arg},
        # Start to serve requests, typically the last entry
        SkaleckiDevWeb.Endpoint
      ] ++ ecto_children()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SkaleckiDev.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SkaleckiDevWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp ecto_children do
    if Application.get_env(:skalecki_dev, :start_ecto, false) do
      [
        SkaleckiDev.Repo,
        {Ecto.Migrator,
         repos: Application.fetch_env!(:skalecki_dev, :ecto_repos), skip: skip_migrations?()}
      ]
    else
      []
    end
  end

  defp skip_migrations?() do
    # By default, sqlite migrations are run when using a release
    System.get_env("RELEASE_NAME") == nil
  end
end
