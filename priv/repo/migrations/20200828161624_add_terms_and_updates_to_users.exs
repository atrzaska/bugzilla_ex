defmodule Bugzilla.Repo.Migrations.AddTermsAndUpdatesToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :terms_accepted, :boolean, null: false, default: false
      add :receive_news_and_updates, :boolean, null: false, default: false
    end
  end
end
