defmodule BugzillaWeb.Helpers.RedirectBack do
  def redirect_back(conn, opts \\ []) do
    Phoenix.Controller.redirect(conn, to: NavigationHistory.last_path(conn, opts))
  end
end
