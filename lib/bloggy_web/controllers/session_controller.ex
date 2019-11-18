defmodule BloggyWeb.SessionController do
  use BloggyWeb, :controller

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias Bloggy.Repo
  alias Bloggy.Accounts
  alias Bloggy.Accounts.User

  plug :scrub_params, "session" when action in ~w(create)a

  def new(conn, _params) do
    IO.puts("Hi, i'm here")
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    # try to get user by unique email from DB
    user = Repo.get_by(User, email: email)
    # examine the result
    result = cond do
      # if user was found and provided password hash equals to stored
      # hash
      user && checkpw(password, user.password_hash) ->
        {:ok, login(conn, user)}
      # else if we just found the use
      user ->
        {:error, :unauthorized, conn}
      # otherwise
      true ->
        # simulate check password hash timing
        dummy_checkpw
        {:error, :not_found, conn}
    end
    case result do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "You’re now logged in!")
        |> redirect(to: Routs.page_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid email/password combination")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    # here will be an implementation
  end

  defp login(conn, user) do
    conn
    |> Guardian.Plug.sign_in(user)
  end

end
