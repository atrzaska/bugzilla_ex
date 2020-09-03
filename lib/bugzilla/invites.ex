defmodule Bugzilla.Invites do
  import Ecto.Query, warn: false
  alias Bugzilla.Repo

  alias Bugzilla.Invites.Invite
  alias Bugzilla.Uid

  def get_invite_by_token!(token) do
    Invite |> Repo.get_by!(token: token)
  end

  def confirm_token!(token, user) do
    get_invite_by_token!(token)
    |> update_invite(%{recipient_id: user.id, confirmed_at: Timex.now}) |> elem(1)
    |> Repo.preload(:project)
  end

  def create_invite(attrs \\ %{}, sender: sender, project: project) do
    token = Uid.guid

    %Invite{sender_id: sender.id, project_id: project.id, token: token}
    |> Invite.changeset(attrs)
    |> Repo.insert()
  end

  def update_invite(%Invite{} = invite, attrs) do
    invite
    |> Invite.changeset(attrs)
    |> Repo.update()
  end
end
