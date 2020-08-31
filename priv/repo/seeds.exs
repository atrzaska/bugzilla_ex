# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Bugzilla.Repo.insert!(%Bugzilla.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Bugzilla.Accounts.User
alias Bugzilla.Accounts
alias Bugzilla.UserProjects
alias Bugzilla.Projects
alias Bugzilla.Projects.Project
alias Bugzilla.Repo
alias Bugzilla.Stories

Project |> Repo.delete_all()
User |> Repo.delete_all()

{:ok, john} = Accounts.register_user(%{
  "name" => "John Doe",
  "email" => "john@bugzilla.app",
  "password" => "password",
  "terms_accepted" => "true",
  "receive_news_and_updates" => "true"
})

{:ok, jane} = Accounts.register_user(%{
  "name" => "Jane Doe",
  "email" => "jane@bugzilla.app",
  "password" => "password",
  "terms_accepted" => "true",
  "receive_news_and_updates" => "true"
})

john |> User.confirm_changeset() |> Repo.update()
jane |> User.confirm_changeset() |> Repo.update()
{:ok, project} = Projects.create_project(%{ "name" => "Bugzilla"})

{:ok, owner} = UserProjects.create_owner(project: project, user: john)
{:ok, member} = UserProjects.create_member(project: project, user: jane)
{:ok, story} = Stories.create_story(%{name: "test", description: "test"}, user: john, project: project)
