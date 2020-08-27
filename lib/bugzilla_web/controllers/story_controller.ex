defmodule BugzillaWeb.StoryController do
  use BugzillaWeb, :controller

  alias Bugzilla.Stories
  alias Bugzilla.Projects
  alias Bugzilla.Stories.Story

  def index(conn, _params) do
    stories = Stories.list_stories()
    render(conn, "index.html", stories: stories)
  end

  def new(conn, _params) do
    user = conn.assigns.current_user
    changeset = Stories.change_story(%Story{creator_id: user.id})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"story" => story_params}) do
    user = conn.assigns.current_user
    project_id = story_params["project_id"]
    project = Projects.get_project!(project_id, user: user)

    case Stories.create_story(story_params, user: user, project: project) do
      {:ok, story} ->
        conn
        |> put_flash(:info, "Story created successfully.")
        |> redirect(to: Routes.story_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    story = Stories.get_story!(id)
    render(conn, "show.html", story: story)
  end

  def edit(conn, %{"id" => id}) do
    story = Stories.get_story!(id)
    changeset = Stories.change_story(story)
    render(conn, "edit.html", story: story, changeset: changeset)
  end

  def update(conn, %{"id" => id, "story" => story_params}) do
    user = conn.assigns.current_user
    project_id = story_params["project_id"]
    project = Projects.get_project!(project_id, user: user)
    story = Stories.get_story!(id, project: project)

    case Stories.update_story(story, story_params) do
      {:ok, story} ->
        conn
        |> put_flash(:info, "Story updated successfully.")
        |> redirect(to: Routes.story_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", story: story, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    story = Stories.get_story!(id)
    {:ok, _story} = Stories.delete_story(story)

    conn
    |> put_flash(:info, "Story deleted successfully.")
    |> redirect(to: Routes.story_path(conn, :index))
  end
end
