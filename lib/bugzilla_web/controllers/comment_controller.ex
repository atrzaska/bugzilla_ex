defmodule BugzillaWeb.CommentController do
  use BugzillaWeb, :controller

  alias Bugzilla.Comments
  alias Bugzilla.Comments.Comment
  alias Bugzilla.Stories

  def new(conn, _params) do
    user = conn.assigns.current_user
    story_id = conn |> get_session(:current_story_id)
    story = Stories.get_story_and_project!(story_id, user: user)
    project = story.project
    changeset = Comments.change_comment(%Comment{user_id: user.id})

    conn
    |> assign(:story, story)
    |> assign(:project, project)
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"comment" => comment_params}) do
    user = conn.assigns.current_user
    story_id = conn |> get_session(:current_story_id)
    story = Stories.get_story_and_project!(story_id, user: user)
    project = story.project

    case Comments.create_comment(comment_params, user: user, story: story) do
      {:ok, _comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
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
    comment = Comments.get_comment!(id, user: user)
    changeset = Comments.change_comment(comment)

    conn
    |> assign(:story, story)
    |> assign(:project, project)
    |> render("edit.html", comment: comment, changeset: changeset)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    user = conn.assigns.current_user
    comment = Comments.get_comment!(id, user: user)
    story_id = conn |> get_session(:current_story_id)
    story = Stories.get_story_and_project!(story_id, user: user)
    project = story.project

    case Comments.update_comment(comment, comment_params) do
      {:ok, _comment} ->
        conn
        |> put_flash(:info, "Comment updated successfully.")
        |> redirect(to: Routes.project_story_path(conn, :edit, project, story))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", comment: comment, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = conn.assigns.current_user
    comment = Comments.get_comment!(id, user: user)
    story_id = conn |> get_session(:current_story_id)
    story = Stories.get_story_and_project!(story_id, user: user)
    project = story.project

    {:ok, _comment} = Comments.delete_comment(comment)

    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: Routes.project_story_path(conn, :edit, project, story))
  end
end
