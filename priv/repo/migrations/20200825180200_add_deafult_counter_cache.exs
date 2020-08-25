defmodule Bugzilla.Repo.Migrations.AddDeafultCounterCache do
  use Ecto.Migration

  def change do
    alter table(:stories) do
      remove :tasks_count
      remove :comments_count
      add :tasks_count, :integer, null: false, default: 0
      add :comments_count, :integer, null: false, default: 0
    end
  end
end
