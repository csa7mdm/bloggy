defmodule BloggyWeb.SessionController do
  use BloggyWeb, :controller

  alias Bloggy.Repo
  alias Bloggy.Accounts.User
  alias BloggyWeb.Auth.Guardian

  def new(conn, _params) do
    render(conn, :new)
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    user = Repo.get_by(User, email: email)

    result =
      cond do
        user && Bcrypt.verify_pass(password, user.encrypted_password) ->
          {:ok, login(conn, user)}

        user ->
          {:error, :unauthorized, conn}

        true ->
          Bcrypt.no_user_verify()
          {:error, :not_found, conn}
      end

    case result do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "You're now logged in!")
        |> redirect(to: ~p"/posts")

      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid email/password combination")
        |> render(:new)
    end
  end

  def delete(conn, _params) do
    conn
    |> logout()
    |> put_flash(:info, "See you later!")
    |> redirect(to: ~p"/")
  end

  defp login(conn, user) do
    Guardian.Plug.sign_in(conn, user)
  end

  defp logout(conn) do
    Guardian.Plug.sign_out(conn)
  end
end
