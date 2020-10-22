defmodule ApperbackWeb.Router do
  use ApperbackWeb, :router

  import ApperbackWeb.Plugs.Authorize

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :authenticated do
    plug :user_check
  end

  pipeline :user do
    plug ApperbackWeb.AuthenticateToken,
      user_context: Apperback.User,
      token_module: ApperbackWeb.Auth.UserToken
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/healthcheck", ApperbackWeb do
    get "/", HealthCheckController, :index
  end

  scope "/api/auth", ApperbackWeb do
    pipe_through :api
    pipe_through :user
    pipe_through :authenticated

    post "/check", AuthController, :check
  end

  scope "/api/auth", ApperbackWeb do
    pipe_through :api
    pipe_through :user

    post "/sign", AuthController, :sign
  end

  scope "/api/projects", ApperbackWeb do
    pipe_through :api
    pipe_through :user
    pipe_through :authenticated

    get "/", ProjectController, :list
    get "/:id", ProjectController, :show
    post "/", ProjectController, :create
    put "/:id", ProjectController, :update
    post "/:project_id/pages", PageController, :create
    put "/:project_id/pages/:id", PageController, :update
  end

  # Other scopes may use custom stacks.
  # scope "/api", ApperbackWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: ApperbackWeb.Telemetry
    end
  end
end
