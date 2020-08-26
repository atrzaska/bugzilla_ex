defmodule Bugzilla.Comments do
  import Ecto.Query, warn: false
  alias Bugzilla.Repo

  alias Bugzilla.Comments.Comment

  def list_comments do
    Repo.all(Comment)
  end

  def get_comment!(id, user: user) do
    Comment |> Repo.get_by!(user_id: user.id, id: id)
  end

  def get_comment!(id), do: Repo.get!(Comment, id)

  def create_comment(attrs \\ %{}, user: user) do
    %Comment{user_id: user.id}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end
end
