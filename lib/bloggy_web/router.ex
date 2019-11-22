defmodule BloggyWeb.Router do
  use BloggyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
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
    pipe_through :browser
    pipe_through :with_session
    pipe_through(:authenticated)

    # resources("/", PageController, only: [:index])

    resources("/posts", PostController,
      only: [:index, :new, :create, :edit, :show, :delete, :update]
    )

    resources("/users", UserController,
      only: [:index, :new, :create, :edit, :show, :delete, :update]
    )

    resources("/companies", CompanyController,
      only: [:index, :new, :create, :edit, :show, :delete, :update]
    )

    # resources("/sessions", SessionController, only: [:new, :create, :delete])
  end

  scope "/", BloggyWeb do
    # , :with_session]
    pipe_through :browser
    pipe_through :with_session

    resources("/", PageController, only: [:index])

    resources("/sessions", SessionController, only: [:new, :create, :delete])
  end
end
