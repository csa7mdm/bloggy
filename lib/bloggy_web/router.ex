defmodule BloggyWeb.Router do
  use BloggyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BloggyWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
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
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", BloggyWeb do
    pipe_through [:browser, :with_session, :authenticated]

    resources "/posts", PostController, only: [:index, :new, :create, :edit, :show, :delete, :update]
    resources "/users", UserController, only: [:index, :edit, :show, :delete, :update]
    resources "/companies", CompanyController, only: [:index, :new, :create, :edit, :show, :delete, :update]
  end

  scope "/", BloggyWeb do
    pipe_through [:browser, :with_session]

    get "/", PageController, :home
    resources "/users", UserController, only: [:new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

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
