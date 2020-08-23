defmodule Bugzilla.Repo.Migrations.CreateMembers do
  use Ecto.Migration

  def change do
    create table(:user_projects) do
      add :project_id, references(:projects)
      add :user_id, references(:users)

      timestamps()
    end

    create index(:user_projects, [:project_id])
    create index(:user_projects, [:user_id])
    create unique_index(:user_projects, [:user_id, :project_id])
  end
end
