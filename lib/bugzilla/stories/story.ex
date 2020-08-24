defmodule Bugzilla.Stories.Story do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bugzilla.Projects.Project
  alias Bugzilla.Accounts.User

  schema "stories" do
    field :name, :string
    field :state, :integer
    field :description, :string
    field :story_type, :integer
    field :container, :integer
    field :tasks_count, :integer
    field :comments_count, :integer

    belongs_to :project, Project
    belongs_to :creator, User

    timestamps()
  end

  @doc false
  def changeset(story, attrs) do
    story
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
