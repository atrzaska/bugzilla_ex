defmodule Bugzilla.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Bugzilla.Repo,
      # Start the Telemetry supervisor
      BugzillaWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Bugzilla.PubSub},
      # Start the Endpoint (http/https)
      BugzillaWeb.Endpoint,
      # Start the absinthe subscription server when the application starts
      absinthe_subscriptions(BugzillaWeb.Endpoint)
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bugzilla.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BugzillaWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  def absinthe_subscriptions(name) do
    %{
      type: :supervisor,
      id: Absinthe.Subscription,
      start: {Absinthe.Subscription, :start_link, [name]}
    }
  end
end
