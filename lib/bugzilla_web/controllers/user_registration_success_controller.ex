defmodule BugzillaWeb.UserRegistrationSuccessController do
  use BugzillaWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
