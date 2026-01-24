defmodule BloggyWeb.UserController do
  use BloggyWeb, :controller

  alias Bloggy.Accounts
  alias Bloggy.Accounts.User
  alias Bloggy.Schema
  alias BloggyWeb.Auth.Guardian

  def index(conn, _params) do
    users = Accounts.list_users()
    companies = Schema.list_companies()
    render(conn, :index, users: users, companies: companies)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        case Guardian.encode_and_sign(user) do
          {:ok, token, _claims} ->
            Accounts.update_user(user, %{token: token})

            conn
            |> put_flash(:info, "User created successfully.")
            |> redirect(to: ~p"/users/#{user}")

          {:error, _reason} ->
            conn
            |> put_flash(:info, "User created successfully.")
            |> redirect(to: ~p"/users/#{user}")
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, :edit, user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: ~p"/users/#{user}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: ~p"/users")
  end
end
