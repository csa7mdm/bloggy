defmodule Bloggy.Repo.Migrations.RenameContentToBodyInPosts do
  use Ecto.Migration

  def change do
    rename table(:posts), :content, to: :body
  end
end
