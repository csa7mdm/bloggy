defmodule BloggyWeb.Router do
  use BloggyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BloggyWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :assign_current_path
  end

  defp assign_current_path(conn, _opts) do
    assign(conn, :current_path, conn.request_path)
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug BloggyWeb.Auth.Pipeline
  end

  pipeline :with_session do
    plug BloggyWeb.Auth.Pipeline
    plug BloggyWeb.Auth.CurrentUser
  end

  pipeline :authenticated do
    plug Guardian.Plug.EnsureAuthenticated
  end

  # Protected routes - authentication required
  scope "/", BloggyWeb do
    pipe_through [:browser, :with_session, :authenticated]

    resources "/posts", PostController, except: [:index, :show]
    resources "/users", UserController, except: [:new, :create]
    resources "/companies", CompanyController
  end

  # Public routes - no authentication required
  scope "/", BloggyWeb do
    pipe_through [:browser, :with_session]

    get "/", PageController, :home
    get "/posts", PostController, :index
    get "/posts/:id", PostController, :show
    get "/users/new", UserController, :new

    # AI Consumption Routes
    get "/llms.txt", LLMController, :index

    post "/users", UserController, :create
    get "/sessions/new", SessionController, :new
    post "/sessions", SessionController, :create
    delete "/sessions/:id", SessionController, :delete
  end

  scope "/api/v1", BloggyWeb do
    pipe_through :api

    get "/posts/:id/context", API.ContextController, :show
  end

  # Protected routes - authentication required

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:bloggy, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BloggyWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
