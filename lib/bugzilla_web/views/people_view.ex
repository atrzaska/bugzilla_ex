defmodule BugzillaWeb.PeopleView do
  import BugzillaWeb.Helpers.Form
  use BugzillaWeb, :view

  alias Bugzilla.UserProjects

  def owner?(conn, project) do
    UserProjects.owner?(user: conn.assigns.user, project: project)
  end

  def me?(conn, user_project) do
    user_project.user_id == conn.assigns.user.id
  end
end
