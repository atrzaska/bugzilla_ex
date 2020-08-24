defmodule Bugzilla.UserProjects do
  import Ecto.Query, warn: false
  alias Bugzilla.Repo

  alias Bugzilla.UserProjects.UserProject

  def list_user_projects do
    Repo.all(UserProject)
  end

  def get_user_project!(id), do: Repo.get!(UserProject, id)

  def create_user_project(attrs \\ %{}) do
    %UserProject{}
    |> UserProject.changeset(attrs)
    |> Repo.insert()
  end

  def update_user_project(%UserProject{} = user_project, attrs) do
    user_project
    |> UserProject.changeset(attrs)
    |> Repo.update()
  end

  def delete_user_project(%UserProject{} = user_project) do
    Repo.delete(user_project)
  end

  def change_user_project(%UserProject{} = user_project, attrs \\ %{}) do
    UserProject.changeset(user_project, attrs)
  end
end
