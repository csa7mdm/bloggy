defmodule BloggyWeb.UserController do
  use BloggyWeb, :controller

  alias Bloggy.Accounts
  alias Bloggy.Accounts.User
  alias Bloggy.Schema
  alias BloggyWeb.Auth.Guardian

  def index(conn, _params) do
    users = Accounts.list_users()
    companies = Schema.list_companies()
    render(conn, "index.html", users: users, companies: companies)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def signin(conn, %{"email" => email, "password" => password}) do
    with {:ok, user, token} <- Guardian.authenticate(email, password) do
      conn
      |> put_status(:created)
      |> redirect(to: Routes.post_path(conn, :index, %{user: user}))
    end
  end

  # def create(conn, %{"user" => user_params}) do
  #   with {:ok, %User{} = user} <- Accounts.create_user(user_params),
  #        {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
  #     conn
  #     |> put_flash(:info, "User created successfully.")
  #     |> redirect(to: Routes.user_path(conn, :show, user, token))
  #   else
  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "new.html", changeset: changeset)
  #   end
  # end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      IO.inspect(user)

      case Guardian.encode_and_sign(user) do
        {:ok, token, _claims} ->
          IO.puts("Here >> 1")
          IO.inspect(token)
          Accounts.update_user(user, %{token: token})

          conn
          |> put_flash(:info, "User created successfully.")
          |> redirect(to: Routes.user_path(conn, :show, user))

        {:error, :secret_not_found} ->
          IO.puts("Here >> 3")
          IO.inspect(Guardian.encode_and_sign(user))

          conn
          |> put_flash(:info, "User created successfully.")
          |> redirect(to: Routes.user_path(conn, :show, user))
      end
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        IO.puts("Here >> 2")
        IO.inspect(changeset)
        render(conn, "new.html", changeset: changeset)
    end
  end

  # def create(conn, %{"user" => user_params}) do
  #   case Accounts.create_user(user_params) do
  #     {:ok, user} ->
  #       conn
  #       |> put_flash(:info, "User created successfully.")
  #       |> redirect(to: Routes.user_path(conn, :show, user))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "new.html", changeset: changeset)
  #   end
  # end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end
end
