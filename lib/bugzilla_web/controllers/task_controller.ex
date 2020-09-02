defmodule BugzillaWeb.TaskController do
  use BugzillaWeb, :controller

  alias Bugzilla.Tasks
  alias Bugzilla.Tasks.Task
  alias Bugzilla.Stories

  def new(conn, _params) do
    user = conn.assigns.current_user
    story_id = conn |> get_session(:current_story_id)
    story = Stories.get_story_and_project!(story_id, user: user)
    project = story.project
    changeset = Tasks.change_task(%Task{})

    conn
    |> assign(:story, story)
    |> assign(:project, project)
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"task" => task_params}) do
    user = conn.assigns.current_user
    story_id = conn |> get_session(:current_story_id)
    story = Stories.get_story_and_project!(story_id, user: user)
    project = story.project

    case Tasks.create_task(task_params, user: user, story: story) do
      {:ok, _task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: Routes.project_story_path(conn, :edit, project, story))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    user = conn.assigns.current_user
    story_id = conn |> get_session(:current_story_id)
    story = Stories.get_story_and_project!(story_id, user: user)
    project = story.project
    task = Tasks.get_task!(id, user: user)
    changeset = Tasks.change_task(task)

    conn
    |> assign(:story, story)
    |> assign(:project, project)
    |> render("edit.html", task: task, changeset: changeset)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    user = conn.assigns.current_user
    task = Tasks.get_task!(id, user: user)
    story_id = conn |> get_session(:current_story_id)
    story = Stories.get_story_and_project!(story_id, user: user)
    project = story.project

    case Tasks.update_task(task, task_params) do
      {:ok, _task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: Routes.project_story_path(conn, :edit, project, story))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task: task, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = conn.assigns.current_user
    task = Tasks.get_task!(id, user: user)
    story_id = conn |> get_session(:current_story_id)
    story = Stories.get_story_and_project!(story_id, user: user)
    project = story.project

    {:ok, _task} = Tasks.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: Routes.project_story_path(conn, :edit, project, story))
  end
end
