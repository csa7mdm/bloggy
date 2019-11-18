defmodule Bloggy.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :company_id, :integer
    field :email, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true
    field :token, :string
    field :role, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :company_id, :token, :role])
    |> validate_required([:email, :password, :company_id, :role])
    |> validate_format(:email, ~r/^[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
    |> validate_length(:password, min: 6)
    |> unique_constraint(:email)
    |> put_hashed_password
  end

  defp put_hashed_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))

      _ ->
        changeset
    end
  end
end
