defmodule Bugzilla.Stories do
  import Ecto.Query, warn: false
  alias Bugzilla.Repo

  alias Bugzilla.Stories.Story
  alias Bugzilla.Projects.Project

  def list_stories do
    Repo.all(Story)
  end

  def list_for_select(user: user) do
    from(s in Story, join: p in Project, on: s.project_id == p.id, where: p.creator_id == ^user.id, select: {s.name, s.id}) |> Repo.all
  end

  def get_story!(id, user: user) do
    Story |> Repo.get_by!(creator_id: user.id, id: id)
  end

  def get_story!(id, project: project) do
    Story |> Repo.get_by!(project_id: project.id, id: id)
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
