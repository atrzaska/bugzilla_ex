defmodule Bugzilla.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :text
      add :story_id, references(:stories)

      timestamps()
    end

    create index(:comments, [:story_id])
  end
end
