defmodule BugzillaWeb.Graphql.Context do
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    context = %{conn: conn, myvar: "myvalue"}
    Absinthe.Plug.put_options(conn, context: context)
  end
end