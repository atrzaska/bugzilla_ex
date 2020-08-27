defmodule BugzillaWeb.CommentView do
  import BugzillaWeb.Helpers.Form
  use BugzillaWeb, :view

  def stories(conn) do
    Bugzilla.Stories.list_for_select(user: conn.assigns.current_user)
  end
end
