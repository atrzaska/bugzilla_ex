defmodule Bugzilla.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bugzilla.Accounts.User

  @derive {Phoenix.Param, key: :slug}
  schema "projects" do
    field :name, :string
    field :slug, :string

    many_to_many :users, User, join_through: "user_projects"

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_length(:name, max: 30)
    |> validate_format(:name, ~r/^[a-zA-Z0-9 ]*$/)
    |> unique_constraint(:slug)
  end
end
