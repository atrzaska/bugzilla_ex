defmodule Bugzilla.UserProjects.UserProject do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bugzilla.Accounts.User
  alias Bugzilla.Projects.Project

  import EctoEnum

  defenum Role, ["member", "owner"]

  schema "user_projects" do
    field :role, Role

    belongs_to :project, Project
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(user_project, attrs) do
    user_project
    |> cast(attrs, [:role, :user_id])
    |> validate_required([:role, :user_id])
  end
end
