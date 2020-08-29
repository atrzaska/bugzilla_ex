defmodule Bugzilla.Repo.Migrations.AddRoleIndex do
  use Ecto.Migration

  def change do
    create index(:user_projects, :role)
  end
end
