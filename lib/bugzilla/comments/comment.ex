defmodule Bugzilla.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Bugzilla.Accounts.User
  alias Bugzilla.Stories.Story

  schema "comments" do
    field :content, :string

    belongs_to :user, User
    belongs_to :story, Story

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content, :story_id])
    |> validate_required([:content, :story_id])
    |> prepare_changes(fn (changeset) ->
      if story_id = get_change(changeset, :story_id) do
        query = from Story, where: [id: ^story_id]
        changeset.repo.update_all(query, inc: [comments_count: 1])
      end

      changeset
    end)
  end
end
