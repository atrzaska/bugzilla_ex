defmodule BugzillaWeb.SharedView do
  use BugzillaWeb, :view

  def bootstrap_nav_item(conn, title, to: to) do
    PhoenixActiveLink.active_link(conn, title, to: to, wrap_tag: 'li', class: "nav-link", wrap_tag_opts: [class: "nav-item"])
  end
end
