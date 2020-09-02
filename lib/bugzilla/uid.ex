defmodule Bugzilla.Uid do
  def uid do
    Ecto.UUID.generate() |> String.split("-") |> Enum.at(0)
  end

  def guid do
    Ecto.UUID.generate() |> String.replace("-", "")
  end
end
