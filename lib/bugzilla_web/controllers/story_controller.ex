defmodule BugzillaWeb.StoryController do
  use BugzillaWeb, :controller

  alias Bugzilla.Stories
  alias Bugzilla.Comments
  alias Bugzilla.Tasks
  alias Bugzilla.Projects
  alias Bugzilla.Stories.Story

  def current(conn, %{"project_id" => project_id}) do
    user = conn.assigns.user
    project = Projects.get_project!(project_id, user: user)
    stories = Stories.list_current_stories(project: project)

    render(conn, "current.html", stories: stories, project: project)
  end

  def backlog(conn, %{"project_id" => project_id}) do
    user = conn.assigns.user
    project = Projects.get_project!(project_id, user: user)
    stories = Stories.list_backlog_stories(project: project)

    render(conn, "backlog.html", stories: stories, project: project)
  end

  def icebox(conn, %{"project_id" => project_id}) do
    user = conn.assigns.user
    project = Projects.get_project!(project_id, user: user)
    stories = Stories.list_icebox_stories(project: project)

    render(conn, "icebox.html", stories: stories, project: project)
  end

  def done(conn, %{"project_id" => project_id}) do
    user = conn.assigns.user
    project = Projects.get_project!(project_id, user: user)
    stories = Stories.list_done_stories(project: project)

    render(conn, "done.html", stories: stories, project: project)
  end

  def new(conn, %{"project_id" => project_id}) do
    user = conn.assigns.user
    project = Projects.get_project!(project_id, user: user)
    changeset = Stories.change_story(%Story{creator_id: user.id, project: project.id})

    render(conn, "new.html", changeset: changeset, project: project)
  end

  def create(conn, %{"project_id" => project_id, "story" => story_params}) do
    user = conn.assigns.user
    project = Projects.get_project!(project_id, user: user)

    case Stories.create_story(story_params, user: user, project: project) do
      {:ok, _story} ->
        conn
        |> put_flash(:info, "Story created successfully.")
        |> redirect(to: Routes.project_story_path(conn, :icebox, project))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, project: project)
    end
  end

  def show(conn, %{"project_id" => project_id, "id" => id}) do
    user = conn.assigns.user
    project = Projects.get_project!(project_id, user: user)
    story = Stories.get_story!(id, project: project)

    render(conn, "show.html", story: story, project: project)
  end

  def edit(conn, %{"project_id" => project_id, "id" => id}) do
    user = conn.assigns.user
    project = Projects.get_project!(project_id, user: user)
    story = Stories.get_story!(id, project: project)
    changeset = Stories.change_story(story)
    comments = Comments.list_comments(story: story)
    tasks = Tasks.list_tasks(story: story)

    conn
    |> put_session(:current_story_id, story.id)
    |> render("edit.html",
      story: story,
      changeset: changeset,
      project: project,
      comments: comments,
      tasks: tasks
    )
  end

  def update(conn, %{"project_id" => project_id, "id" => id, "story" => story_params}) do
    user = conn.assigns.user
    project = Projects.get_project!(project_id, user: user)
    story = Stories.get_story!(id, project: project)

    case Stories.update_story(story, story_params) do
      {:ok, _story} ->
        conn
        |> put_flash(:info, "Story updated successfully.")
        |> redirect_back(default: Routes.project_story_path(conn, :current, project))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", story: story, changeset: changeset, project: project)
    end
  end

  def delete(conn, %{"project_id" => project_id, "id" => id}) do
    user = conn.assigns.user
    project = Projects.get_project!(project_id, user: user)
    story = Stories.get_story!(id, project: project)
    {:ok, _story} = Stories.delete_story(story)

    conn
    |> put_flash(:info, "Story deleted successfully.")
    |> redirect_back(default: Routes.project_story_path(conn, :current, project))
  end
end
