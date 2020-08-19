defmodule BugzillaWeb.Helpers.Form do
  def invalid_field_class(form, field) do
    if form.errors[field] == nil, do: nil, else: "is-invalid"
  end
end
