defmodule BugzillaWeb.InvitationController do
  use BugzillaWeb, :controller

  alias Bugzilla.Invitations

  def show(conn, %{"id" => id}) do
    invitation = Invitations.get_invitation!(id)
    render(conn, "show.html", invitation: invitation)
  end
end
