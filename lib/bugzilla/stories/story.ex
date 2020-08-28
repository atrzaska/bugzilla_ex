defmodule Bugzilla.Stories.Story do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bugzilla.Projects.Project
  alias Bugzilla.Accounts.User

  import EctoEnum

  defenum State, ["unstarted", "started", "finished", "delivered", "accepted", "rejected"]
  defenum Type, ["feature", "bug", "chore", "release"]
  defenum Container, ["icebox", "backlog"]

  schema "stories" do
    field :name, :string
    field :state, State
    field :description, :string
    field :story_type, Type
    field :container, Container
    field :tasks_count, :integer
    field :comments_count, :integer

    belongs_to :project, Project
    belongs_to :creator, User

    timestamps()
  end

  @doc false
  def changeset(story, attrs) do
    story
    |> cast(attrs, [:name, :state, :description, :story_type, :container])
    |> validate_required([:name, :state, :description, :story_type, :container])
  end
end
