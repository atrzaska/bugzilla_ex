defmodule Bugzilla.Repo.Migrations.StringEnums do
  use Ecto.Migration

  def change do
    alter table(:stories) do
      remove :state
      remove :container
      remove :story_type

      add :state, :string, default: "unstarted", null: false
      add :container, :string, default: "icebox", null: false
      add :story_type, :string, default: "feature", null: false
    end

    create index(:stories, [:container])
    create index(:stories, [:story_type])
    create index(:stories, [:state])
  end
end
