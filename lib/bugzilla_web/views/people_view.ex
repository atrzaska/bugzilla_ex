defmodule BugzillaWeb.PeopleView do
  import BugzillaWeb.Helpers.Form
  use BugzillaWeb, :view

  alias Bugzilla.UserProjects
  alias Bugzilla.UserProjects.UserProject

  def roles do
    UserProject.Role.__enum_map__()
  end

  def owner?(conn, project) do
    UserProjects.owner?(user: conn.assigns.current_user, project: project)
  end

  def me?(conn, user_project) do
    user_project.user_id == conn.assigns.current_user.id
  end
end
