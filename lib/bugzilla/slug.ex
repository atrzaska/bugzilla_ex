defmodule Bugzilla.Slug do
  @reserved_keywords ["new", "edit", "index", "session", "login", "logout", "users", "admin", "stylesheets", "assets", "javascripts", "images"]

  def slug(value) do
    candidate = candidate_slug(value)
    if candidate in @reserved_keywords, do: Ecto.UUID.generate, else: candidate
  end

  def candidate_slug(value) do
    value
    |> String.downcase()
    |> String.replace(~r/[^a-z0-9\s-]/, "")
    |> String.replace(~r/(\s|-)+/, "-")
  end
end
