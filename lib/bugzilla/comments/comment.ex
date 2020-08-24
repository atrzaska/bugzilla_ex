defmodule Bugzilla.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

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
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end
