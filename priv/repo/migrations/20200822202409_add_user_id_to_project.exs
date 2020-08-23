defmodule Bugzilla.Repo.Migrations.AddUserIdToProject do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      add :creator_id, references(:users)
    end

    create index(:projects, [:creator_id])
  end
end
