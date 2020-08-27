defmodule Bugzilla.Projects do
  import Ecto.Query, warn: false

  alias Bugzilla.Repo
  alias Bugzilla.Projects.Project

  def list_projects(user: user) do
    from(p in Project, where: p.creator_id == ^user.id) |> Repo.all
  end

  def list_projects do
    Repo.all(Project)
  end

  def list_for_select(user: user) do
    from(p in Project, where: p.creator_id == ^user.id, select: {p.name, p.id}) |> Repo.all
  end

  def get_project!(id, user: user) do
    Project |> Repo.get_by!(creator_id: user.id, id: id)
  end

  def get_project!(id), do: Repo.get!(Project, id)

  def create_project(attrs \\ %{}, user: user) do
    %Project{creator_id: user.id}
    |> Project.changeset(attrs)
    |> Repo.insert()
  end

  def update_project(%Project{} = project, attrs) do
    project
    |> Project.changeset(attrs)
    |> Repo.update()
  end

  def delete_project(%Project{} = project) do
    Repo.delete(project)
  end

  def change_project(%Project{} = project, attrs \\ %{}) do
    Project.changeset(project, attrs)
  end
end
