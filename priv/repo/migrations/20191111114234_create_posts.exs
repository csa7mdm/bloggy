defmodule Bloggy.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :name, :string
      add :description, :text
      add :tag, :string

      timestamps()
    end

  end
end
