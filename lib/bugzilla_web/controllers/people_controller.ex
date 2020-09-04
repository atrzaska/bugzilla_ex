defmodule BugzillaWeb.PeopleController do
  use BugzillaWeb, :controller

  alias Bugzilla.UserProjects
  alias Bugzilla.Projects

  def index(conn, %{"project_id" => project_id}) do
    user = conn.assigns.user
    project = Projects.get_project!(project_id, user: user)
    user_projects = UserProjects.list_user_projects(project: project)

    conn
    |> put_session(:project_id, project.id)
    |> render("index.html", user_projects: user_projects, project: project)
  end

  def edit(conn, %{"id" => id, "project_id" => project_id}) do
    user = conn.assigns.user
    project = Projects.get_project!(project_id, user: user)
    user_project = UserProjects.get_user_project!(id, project: project)
    changeset = UserProjects.change_user_project(user_project)

    render(conn, "edit.html", user_project: user_project, changeset: changeset, project: project)
  end

  # only allow owners to change role
  def update(conn, %{
        "id" => id,
        "project_id" => project_id,
        "user_project" => user_project_params
      }) do
    user = conn.assigns.user
    project = Projects.get_project!(project_id, user: user)
    user_project = UserProjects.get_user_project!(id, project: project)

    case UserProjects.update_user_project(user_project, user_project_params) do
      {:ok, _user_project} ->
        conn
        |> put_flash(:info, "Member updated successfully.")
        |> redirect(to: Routes.project_people_path(conn, :index, project))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user_project: user_project, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id, "project_id" => project_id}) do
    user = conn.assigns.user
    project = Projects.get_project!(project_id, user: user)
    user_project = UserProjects.get_user_project!(id, project: project)
    {:ok, _user_project} = UserProjects.delete_user_project(user_project)

    if user.id == user_project.user_id do
      conn
      |> put_flash(:info, "Project left successfully.")
      |> redirect(to: Routes.project_path(conn, :index))
    else
      conn
      |> put_flash(:info, "Member deleted successfully.")
      |> redirect(to: Routes.project_people_path(conn, :index, project_id))
    end
  end
end
