defmodule Bugzilla.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bugzilla.Stories.Story
  alias Bugzilla.Stories.User

  schema "tasks" do
    field :description, :string
    field :complete, :boolean

    belongs_to :story, Story
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:description, :complete])
    |> validate_required([:description, :story_id, :user_id])
  end
end
