
require IEx

defmodule BugzillaWeb.Graphql.Resolvers do
  alias Bugzilla.Accounts

  def visitor(_parent, _args, _resolution) do
    {:ok, %{
      id: 1,
      name: "Andrzej Trzaka",
      email: "atrzaska2@gmail.com",
      token: "wegeqrwbretrf023d23"
    }}
  end

  def login(_parent, _args, _resolution) do
    {:ok, %{
      id: 1,
      name: "Andrzej Trzaka",
      email: "atrzaska2@gmail.com",
      token: "wegeqrwbretrf023d23"
    }}
  end

  # def signup(parent, args, resolution) do
  def signup(args, info) do
      IEx.pry
    case Accounts.register_user(args) do
      {:ok, user} ->
        # {:ok, _} =
        #   Accounts.deliver_user_confirmation_instructions(
        #     user,
        #     &Routes.user_confirmation_url(conn, :confirm, &1)
        #   )

        {:ok, user}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, changeset}
    end
  end
end
