defmodule BugzillaWeb.UserProjectController do
  use BugzillaWeb, :controller

  alias Bugzilla.UserProjects
  alias Bugzilla.UserProjects.UserProject

  def index(conn, _params) do
    user_projects = UserProjects.list_user_projects()
    render(conn, "index.html", user_projects: user_projects)
  end

  def new(conn, _params) do
    changeset = UserProjects.change_user_project(%UserProject{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user_project" => user_project_params}) do
    case UserProjects.create_user_project(user_project_params) do
      {:ok, user_project} ->
        conn
        |> put_flash(:info, "UserProject created successfully.")
        |> redirect(to: Routes.user_project_path(conn, :show, user_project))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user_project = UserProjects.get_user_project!(id)
    render(conn, "show.html", user_project: user_project)
  end

  def edit(conn, %{"id" => id}) do
    user_project = UserProjects.get_user_project!(id)
    changeset = UserProjects.change_user_project(user_project)
    render(conn, "edit.html", user_project: user_project, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user_project" => user_project_params}) do
    user_project = UserProjects.get_user_project!(id)

    case UserProjects.update_user_project(user_project, user_project_params) do
      {:ok, user_project} ->
        conn
        |> put_flash(:info, "UserProject updated successfully.")
        |> redirect(to: Routes.user_project_path(conn, :show, user_project))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user_project: user_project, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_project = UserProjects.get_user_project!(id)
    {:ok, _user_project} = UserProjects.delete_user_project(user_project)

    conn
    |> put_flash(:info, "UserProject deleted successfully.")
    |> redirect(to: Routes.user_project_path(conn, :index))
  end
end
