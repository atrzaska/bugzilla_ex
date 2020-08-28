defmodule Bugzilla.Stories do
  import Ecto.Query, warn: false
  alias Bugzilla.Repo

  alias Bugzilla.Stories.Story
  alias Bugzilla.Projects.Project

  def list_current_stories(project: project) do
    from(s in Story,
      join: p in Project,
      on: s.project_id == p.id,
      where: s.state in ^[:started, :finished, :delivered, :rejected],
      where: p.id == ^project.id
    ) |> Repo.all
  end

  def list_backlog_stories(project: project) do
    from(s in Story,
      join: p in Project,
      on: s.project_id == p.id,
      where: s.state == ^:unstarted,
      where: s.container == ^:backlog,
      where: p.id == ^project.id
    ) |> Repo.all
  end

  def list_icebox_stories(project: project) do
    from(s in Story,
      join: p in Project,
      on: s.project_id == p.id,
      where: s.state == ^:unstarted,
      where: s.container == ^:icebox,
      where: p.id == ^project.id
    ) |> Repo.all
  end

  def list_done_stories(project: project) do
    from(s in Story,
      join: p in assoc(s, :project),
      on: s.project_id == p.id,
      where: s.state == ^:accepted,
      where: p.id == ^project.id
    ) |> Repo.all
  end

  def list_for_select(user: user) do
    from(s in Story,
      join: p in assoc(s, :project),
      on: s.project_id == p.id,
      join: u in UserProject,
      on: p.id == u.project_id,
      where: u.user_id == ^user.id,
      select: {s.name, s.id}
    ) |> Repo.all
  end

  def get_story!(id, user: user) do
    Story |> Repo.get_by!(creator_id: user.id, id: id)
  end

  def get_story!(id, project: project) do
    Story |> Repo.get_by!(project_id: project.id, id: id)
  end

  def get_story!(id), do: Repo.get!(Story, id)

  def create_story(attrs \\ %{}, user: user, project: project) do
    %Story{creator_id: user.id, project_id: project.id, state: :unstarted}
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
