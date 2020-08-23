defmodule Bugzilla.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :description, :text
      add :story_id, references(:stories)
      add :complete, :boolean

      timestamps()
    end

    create index(:tasks, [:story_id])
    create index(:tasks, [:complete])
  end
end
