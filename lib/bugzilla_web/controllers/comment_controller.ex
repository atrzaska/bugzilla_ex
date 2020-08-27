defmodule BugzillaWeb.CommentController do
  use BugzillaWeb, :controller

  alias Bugzilla.Comments
  alias Bugzilla.Comments.Comment

  def index(conn, _params) do
    comments = Comments.list_comments()
    render(conn, "index.html", comments: comments)
  end

  def new(conn, _params) do
    user = conn.assigns.current_user
    changeset = Comments.change_comment(%Comment{user_id: user.id})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"comment" => comment_params}) do
    user = conn.assigns.current_user

    case Comments.create_comment(comment_params, user: user) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: Routes.comment_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = conn.assigns.current_user
    comment = Comments.get_comment!(id, user: user)
    render(conn, "show.html", comment: comment)
  end

  def edit(conn, %{"id" => id}) do
    user = conn.assigns.current_user
    comment = Comments.get_comment!(id, user: user)
    changeset = Comments.change_comment(comment)
    render(conn, "edit.html", comment: comment, changeset: changeset)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    user = conn.assigns.current_user
    comment = Comments.get_comment!(id, user: user)

    case Comments.update_comment(comment, comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment updated successfully.")
        |> redirect(to: Routes.comment_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", comment: comment, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = conn.assigns.current_user
    comment = Comments.get_comment!(id, user: user)
    {:ok, _comment} = Comments.delete_comment(comment)

    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: Routes.comment_path(conn, :index))
  end
end
