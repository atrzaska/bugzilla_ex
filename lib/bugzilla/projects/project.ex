defmodule Bugzilla.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bugzilla.Accounts.User

  schema "projects" do
    field :name, :string

    belongs_to :creator, User
    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_length(:name, max: 30)
    |> validate_format(:name, ~r/^[a-zA-Z0-9 ]*$/)
  end
end
