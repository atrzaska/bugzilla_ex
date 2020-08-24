defmodule Bugzilla.UserProjects.UserProject do
  use Ecto.Schema

  alias Bugzilla.Accounts.User
  alias Bugzilla.Projects.Project

  schema "user_projects" do
    belongs_to :project, Project
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(user_project, _attrs) do
    user_project
  end
end
