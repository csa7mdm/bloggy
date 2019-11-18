defmodule Bloggy.Repo.Migrations.AddingRelations do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :company_id, references(:companies, on_delete: :nothing)

    end

    alter table(:posts) do
      modify :created_by, references(:users, on_delete: :nothing)
      modify :company_id, references(:companies, on_delete: :nothing)

    end

  end
end
