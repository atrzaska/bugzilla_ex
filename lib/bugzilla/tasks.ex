defmodule Bugzilla.Tasks do
  import Ecto.Query, warn: false
  alias Bugzilla.Repo

  alias Bugzilla.Tasks.Task

  def list_tasks do
    Repo.all(Task)
  end

  def list_tasks(story: story) do
    from(t in Task, where: t.story_id == ^story.id) |> Repo.all()
  end

  def get_task!(id, user: user) do
    Task |> Repo.get_by!(user_id: user.id, id: id)
  end

  def get_task!(id), do: Repo.get!(Task, id)

  def create_task(attrs \\ %{}, user: user, story: story) do
    %Task{user_id: user.id, story_id: story.id}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end
end
