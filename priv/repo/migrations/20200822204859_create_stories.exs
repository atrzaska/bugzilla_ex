defmodule Bugzilla.Repo.Migrations.CreateStories do
  use Ecto.Migration

  def change do
    create table(:stories) do
      add :name, :string
      add :state, :integer
      add :description, :string
      add :story_type, :integer
      add :container, :integer
      add :tasks_count, :integer
      add :comments_count, :integer
      add :project_id, references(:projects)
      add :creator_id, references(:users)

      timestamps()
    end

    create index(:stories, [:project_id])
    create index(:stories, [:creator_id])
    create index(:stories, [:container])
    create index(:stories, [:story_type])
    create index(:stories, [:state])
  end
end
