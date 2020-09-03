defmodule Bugzilla.Repo.Migrations.CreateInvitations do
  use Ecto.Migration

  def change do
    create table(:invites) do
      add :email, :string
      add :project_id, references(:projects, on_delete: :delete_all)
      add :sender_id, references(:users, on_delete: :delete_all)
      add :recipient_id, references(:users, on_delete: :delete_all)
      add :confirmed_at, :naive_datetime
      add :token, :string

      timestamps()
    end

    create index(:invites, :project_id)
    create index(:invites, :sender_id)
    create index(:invites, :recipient_id)
    create index(:invites, :token)
    create index(:invites, :email)
  end
end
