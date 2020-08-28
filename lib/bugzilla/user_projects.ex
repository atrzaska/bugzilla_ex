defmodule Bugzilla.UserProjects do
  import Ecto.Query, warn: false
  alias Bugzilla.Repo

  alias Bugzilla.UserProjects.UserProject

  def list_user_projects(project: project) do
    from(p in UserProject, where: p.project_id == ^project.id, preload: [:user]) |> Repo.all
  end

  def list_user_projects do
    Repo.all(UserProject)
  end

  def get_user_project!(id, project: project) do
    UserProject |> Repo.get_by!(project_id: project.id, id: id) |> Repo.preload(:user)
  end

  def create_user_project(attrs \\ %{}, project: project) do
    %UserProject{project_id: project.id}
    |> UserProject.changeset(attrs)
    |> Repo.insert()
  end

  def create_owner(project: project, user: user) do
    %UserProject{project_id: project.id, user_id: user.id, role: :owner} |> Repo.insert()
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

  def role(user: user, project: project) do
    from(u in UserProject,
      where: u.user_id == ^user.id,
      where: u.project_id == ^project.id,
      select: {u.role}
    ) |> Repo.one() |> elem(0)
  end

  def owner?(user: user, project: project) do
    role(user: user, project: project) == :owner
  end
end
