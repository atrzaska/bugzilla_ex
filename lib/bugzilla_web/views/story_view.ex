defmodule BugzillaWeb.StoryView do
  import BugzillaWeb.Helpers.Form
  use BugzillaWeb, :view

  alias Bugzilla.Comments.Comment

  def states do
    Bugzilla.Stories.Story.State.__enum_map__()
  end

  def types do
    Bugzilla.Stories.Story.Type.__enum_map__()
  end

  def containers do
    Bugzilla.Stories.Story.Container.__enum_map__()
  end

  def owner?(conn, %Comment{} = comment) do
    comment.user_id == conn.assigns.current_user.id
  end
end
