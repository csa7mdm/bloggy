defmodule Bloggy.Repo.Migrations.AddEmbeddingToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :embedding, :vector, size: 1536
    end
  end
end
