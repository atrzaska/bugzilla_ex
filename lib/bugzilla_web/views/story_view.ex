defmodule BugzillaWeb.StoryView do
  import BugzillaWeb.Helpers.Form
  use BugzillaWeb, :view

  def states do
    Bugzilla.Stories.Story.State.__enum_map__()
  end

  def types do
    Bugzilla.Stories.Story.Type.__enum_map__()
  end

  def containers do
    Bugzilla.Stories.Story.Container.__enum_map__()
  end
end
