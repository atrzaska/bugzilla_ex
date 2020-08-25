defmodule Bugzilla.Repo.Migrations.StringEnums do
  use Ecto.Migration

  def change do
    alter table(:stories) do
      remove :state
      remove :container
      remove :story_type

      add :state, :string
      add :container, :string
      add :story_type, :string
    end

    create index(:stories, [:container])
    create index(:stories, [:story_type])
    create index(:stories, [:state])
  end
end
