defmodule Bloggy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BloggyWeb.Telemetry,
      Bloggy.Repo,
      {DNSCluster, query: Application.get_env(:bloggy, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Bloggy.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Bloggy.Finch},
      # Start the Plugin Manager
      Bloggy.PluginManager,
      # Start a worker by calling: Bloggy.Worker.start_link(arg)
      # {Bloggy.Worker, arg},
      # Start to serve requests, typically the last entry
      BloggyWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bloggy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BloggyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
