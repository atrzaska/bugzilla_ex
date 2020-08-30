defmodule Bugzilla.Repo.Migrations.AddSlugToProjects do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      add :slug, :string
    end

    create index(:projects, [:slug], unique: true)
  end
end
