defmodule BugzillaWeb.InviteController do
  use BugzillaWeb, :controller

  alias Bugzilla.Invites
  alias Bugzilla.Invites.Invite
  alias Bugzilla.Projects
  alias Bugzilla.Mailer
  alias Bugzilla.UserProjects

  def new(conn, _params) do
    user = conn.assigns.user
    project_id = conn |> get_session(:project_id)
    project = Projects.get_project!(project_id, user: user)
    changeset = Invites.change_invite(%Invite{})
    render(conn, "new.html", changeset: changeset, project: project)
  end

  def create(conn, %{"invite" => invite_params}) do
    user = conn.assigns.user
    project_id = conn |> get_session(:project_id)
    project = Projects.get_project!(project_id, user: user)

    case Invites.create_invite(invite_params, sender: user, project: project) do
      {:ok, invite} ->
        Mailer.deliver_invitation_email(invite |> Map.merge(%{project: project, sender: user}))

        conn
        |> put_flash(:info, "Invite sent.")
        |> redirect(to: Routes.project_people_path(conn, :index, project))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def confirm(conn, %{"token" => token}) do
    user = conn.assigns.user
    invite = Invites.confirm_token!(token, user)
    project = invite.project

    UserProjects.create_member(project: project, user: user)

    conn
    |> put_flash(:info, "Invite accepted.")
    |> redirect(to: Routes.dashboard_path(conn, :index))
  end
end
