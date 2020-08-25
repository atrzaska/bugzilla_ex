defmodule Bugzilla.Stories do
  import Ecto.Query, warn: false
  alias Bugzilla.Repo

  alias Bugzilla.Stories.Story

  def list_stories do
    Repo.all(Story)
  end

  def get_story!(id), do: Repo.get!(Story, id)

  def create_story(attrs \\ %{}, user: user, project: project) do
    %Story{creator_id: user.id, project_id: project.id}
    |> Story.changeset(attrs)
    |> Repo.insert()
  end

  def update_story(%Story{} = story, attrs) do
    story
    |> Story.changeset(attrs)
    |> Repo.update()
  end

  def delete_story(%Story{} = story) do
    Repo.delete(story)
  end

  def change_story(%Story{} = story, attrs \\ %{}) do
    Story.changeset(story, attrs)
  end
end
