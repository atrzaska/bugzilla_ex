defmodule Bugzilla.Invites.Invite do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bugzilla.Accounts.User
  alias Bugzilla.Projects.Project

  schema "invites" do
    field :email, :string
    field :token, :string
    field :confirmed_at, :naive_datetime

    belongs_to :project, Project
    belongs_to :sender, User
    belongs_to :recipient, User

    timestamps()
  end

  @doc false
  def changeset(invite, attrs) do
    invite
    |> cast(attrs, [:email, :token, :recipient_id, :confirmed_at])
    |> validate_required([:email, :token, :project_id, :sender_id])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
  end
end
