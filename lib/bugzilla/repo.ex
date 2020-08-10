defmodule Bugzilla.Repo do
  use Ecto.Repo,
    otp_app: :bugzilla,
    adapter: Ecto.Adapters.Postgres
end
