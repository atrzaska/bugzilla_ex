defmodule BugzillaWeb.Graphql.Schema do
  use Absinthe.Schema

  import_types(BugzillaWeb.Graphql.Schema.User)
  alias BugzillaWeb.Graphql.Resolvers

  query do
    @desc "Current visitor"
    field :visitor, type: :user do
      resolve &Resolvers.visitor/3
    end
  end

  mutation do
    field :login, type: :user do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&Resolvers.login/3)
    end

    field :signup, type: :user do
      arg(:name, non_null(:string))
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      arg(:terms_accepted, non_null(:boolean))
      arg(:receive_news_and_updates, non_null(:boolean))

      resolve(&Resolvers.signup/2)
    end
  end
end