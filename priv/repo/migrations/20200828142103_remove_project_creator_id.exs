defmodule Bugzilla.Repo.Migrations.RemoveProjectCreatorId do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      remove :creator_id
    end
  end
end
