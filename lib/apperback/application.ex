defmodule Apperback.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    mongo_url =
      case System.get_env("MIX_ENV") do
        "test" ->
          fetch_env!(:apperback, :mongo_url)

        _ ->
          "mongodb+srv://#{fetch_env!(:apperback, :mongo_username)}:#{
            fetch_env!(:apperback, :mongo_password)
          }@#{fetch_env!(:apperback, :mongo_host)}/#{fetch_env!(:apperback, :mongo_database)}?retryWrites=true&w=majority"
      end
    children = [
      # Start the Ecto repository
      # Apperback.Repo,
      # Start the Telemetry supervisor
      ApperbackWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Apperback.PubSub},
      # Start the Endpoint (http/https)
      ApperbackWeb.Endpoint,
      # Start a worker by calling: Apperback.Worker.start_link(arg)
      # {Apperback.Worker, arg}
      worker(Mongo, [
        [
          name: :mongo,
          url: mongo_url,
          pool_size: Application.fetch_env!(:apperback, :mongo_pool_size),
          pool_timeout: 20000,
          connect_timeout: 20000
        ]
      ])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Apperback.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ApperbackWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
