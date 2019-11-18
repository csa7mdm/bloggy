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

  scope "/", BloggyWeb do
    # pipe_through [:browser, :auth]
    pipe_through [:browser]

    get "/", PageController, :index

    resources("/posts", PostController,
      only: [:index, :new, :create, :edit, :show, :delete, :update]
    )

    resources("/users", UserController,
      only: [:index, :new, :create, :edit, :show, :delete, :update]
    )

    resources("/companies", CompanyController,
      only: [:index, :new, :create, :edit, :show, :delete, :update]
    )

    resources("/sessions", SessionController,
    only: [:new, :create, :delete]
    )
  end

  # scope "/", BloggyWeb do
  #   pipe_through [:browser]

  #   get "/", PageController, :index

  #   # resources("/users", UserController,
  #   #   only: [:new, :create, index]
  #   # )
  # end

  # scope "/", BloggyWeb do
  #   pipe_through :browser

  #   get "/", PageController, :index

  #   resources("/posts", PostController,
  #     only: [:index, :new, :create, :edit, :show, :delete, :update]
  #   )

  #   resources("/users", UserController,
  #     only: [:index, :new, :create, :edit, :show, :delete, :update]
  #   )

  #   resources("/companies", CompanyController,
  #     only: [:index, :new, :create, :edit, :show, :delete, :update]
  #   )
  # end

  # Other scopes may use custom stacks.
  # scope "/api", BloggyWeb do
  #   pipe_through :api
  # end
end
