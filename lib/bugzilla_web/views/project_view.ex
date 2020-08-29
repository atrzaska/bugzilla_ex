defmodule BugzillaWeb.ProjectView do
  import BugzillaWeb.Helpers.Form
  use BugzillaWeb, :view

  alias Bugzilla.UserProjects

  def owner?(conn, project) do
    UserProjects.owner?(user: conn.assigns.current_user, project: project)
  end
end
