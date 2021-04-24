defmodule BugzillaWeb.Graphql.Schema.User do
  use Absinthe.Schema.Notation

  object :user do
    field :id, :id
    field :email, :string
    field :name, :string
    field :token, :string
  end
end