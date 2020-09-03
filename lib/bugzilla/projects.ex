defmodule Bugzilla.Projects do
  import Ecto.Query, warn: false

  alias Bugzilla.Repo
  alias Bugzilla.Slug
  alias Bugzilla.Uid
  alias Bugzilla.Projects.Project
  alias Bugzilla.UserProjects.UserProject

  def list_projects(user: user) do
    from(p in Project,
      join: u in UserProject,
      on: u.project_id == p.id,
      where: u.user_id == ^user.id
    ) |> Repo.all
  end

  def list_projects do
    Repo.all(Project)
  end

  def slug_taken?(slug) do
    from(p in Project, where: p.slug == ^slug) |> Repo.exists?
  end

  def get_project!(id, user: user) when is_number(id) do
    from(p in Project,
      join: u in UserProject, on: u.project_id == p.id,
      where: u.user_id == ^user.id,
      where: p.id == ^id
    ) |> Repo.one!
  end

  def get_project!(slug, user: user) do
    from(p in Project,
      join: u in UserProject, on: u.project_id == p.id,
      where: u.user_id == ^user.id,
      where: p.slug == ^slug
    ) |> Repo.one!
  end

  def create_project(attrs \\ %{}) do
    slug = Slug.slug(attrs["name"])
    slug = if slug_taken?(slug), do: "#{slug}-#{Uid.uid}", else: slug

    %Project{slug: slug}
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
