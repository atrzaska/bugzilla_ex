defmodule Bugzilla.Repo.Migrations.AddRoleToUserProjects do
  use Ecto.Migration

  def change do
    alter table(:user_projects) do
      add :role, :string, null: false, default: "member"
    end
  end
end
