defmodule BloggyWeb.SessionController do
  use BloggyWeb, :controller

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias Bloggy.Repo
  # alias Bloggy.Accounts
  alias Bloggy.Accounts.User
  alias BloggyWeb.Auth.Guardian

  plug :scrub_params, "session" when action in ~w(create)a

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    # try to get user by unique email from DB
    user = Repo.get_by(User, email: email)

    # examine the result
    result =
      cond do
        # if user was found and provided password hash equals to stored
        # hash
        user && checkpw(password, user.encrypted_password) ->
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
        IO.puts(
          ">>>>>>>>>>>>>>>>>>>>>Ana hna hna yabn el 7lal 02<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
        )

        IO.inspect(conn)

        conn
        |> put_flash(:info, "You’re now logged in!")
        |> redirect(to: Routes.post_path(conn, :index))

      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid email/password combination")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> logout
    |> put_flash(:info, "See you later!")
    |> redirect(to: Routes.page_path(conn, :index))
  end

  defp login(conn, user) do
    IO.puts(">>>>>>>>>>>>>>>>>>>>>Ana hna hna yabn el 7lal 01<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")

    conn
    |> Guardian.Plug.sign_in(user)
    |> IO.inspect()
  end

  defp logout(conn) do
    IO.inspect(conn)

    conn
    |> Guardian.Plug.sign_out()
  end
end
