defmodule BugzillaWeb.ProjectController do
  use BugzillaWeb, :controller

  alias Bugzilla.Projects
  alias Bugzilla.Projects.Project
  alias Bugzilla.UserProjects

  def index(conn, _params) do
    user = conn.assigns.user
    projects = Projects.list_projects(user: user)

    render(conn, "index.html", projects: projects)
  end

  def new(conn, _params) do
    changeset = Projects.change_project(%Project{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"project" => project_params}) do
    user = conn.assigns.user

    case Projects.create_project(project_params) do
      {:ok, project} ->
        UserProjects.create_owner(project: project, user: user)

        conn
        |> put_flash(:info, "Project created successfully.")
        |> redirect(to: Routes.project_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    user = conn.assigns.user
    project = Projects.get_project!(id, user: user)
    changeset = Projects.change_project(project)

    render(conn, "edit.html", project: project, changeset: changeset)
  end

  def update(conn, %{"id" => id, "project" => project_params}) do
    user = conn.assigns.user
    project = Projects.get_project!(id, user: user)

    case Projects.update_project(project, project_params) do
      {:ok, _project} ->
        conn
        |> put_flash(:info, "Project updated successfully.")
        |> redirect(to: Routes.project_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", project: project, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = conn.assigns.user
    project = Projects.get_project!(id, user: user)

    {:ok, _project} = Projects.delete_project(project)

    conn
    |> put_flash(:info, "Project deleted successfully.")
    |> redirect(to: Routes.project_path(conn, :index))
  end
end
