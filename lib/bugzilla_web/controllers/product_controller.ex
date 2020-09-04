defmodule BugzillaWeb.ProductController do
  use BugzillaWeb, :controller

  def index(conn, _params) do
    if conn.assigns.user do
      conn |> redirect(to: "/dashboard")
    else
      render(conn, "index.html")
    end
  end
end
