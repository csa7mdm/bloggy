defmodule Bloggy.AccountsTest do
  use Bloggy.DataCase

  alias Bloggy.Accounts

  describe "users" do
    alias Bloggy.Accounts.User

    @valid_attrs %{
      company_id: 42,
      email: "some_email@example.com",
      password: "some password",
      role: "some role"
    }
    @update_attrs %{
      email: "some_updated_email@example.com",
      password: "some updated password",
      role: "some updated role"
    }
    @invalid_attrs %{company_id: nil, email: nil, password: nil, role: nil}

    alias Bloggy.Schema.Company
    alias Bloggy.Schema

    def company_fixture() do
      {:ok, company} =
        %{name: "Test Company #{System.unique_integer([:positive])}", parent_id: nil}
        |> Schema.create_company()

      company
    end

    def user_fixture(attrs \\ %{}) do
      company = company_fixture()

      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Map.put(:company_id, company.id)
        |> Map.put(:email, "unique_#{System.unique_integer([:positive])}@example.com")
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert [got] = Accounts.list_users()
      assert got.id == user.id
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      got = Accounts.get_user!(user.id)
      assert got.id == user.id
      assert got.email == user.email
    end

    test "create_user/1 with valid data creates a user" do
      company = company_fixture()
      valid_attrs = Map.put(@valid_attrs, :company_id, company.id)
      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.company_id == company.id
      assert user.email == "some_email@example.com"
      # assert user.encrypted_password == "some encrypted_password"
      assert user.role == "some role"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.email == "some_updated_email@example.com"
      # assert user.encrypted_password == "some updated encrypted_password"
      assert user.role == "some updated role"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert Accounts.get_user!(user.id).email == user.email
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
