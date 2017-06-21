defmodule Rumbl.CategoryRepoTest do
  use Rumbl.ModelCase

  alias Rumbl.Category

  test "alphabetical/1 orders by name" do
    Repo.insert!(%Category{name: "comedy"})
    Repo.insert!(%Category{name: "background"})
    Repo.insert!(%Category{name: "action"})

    query = Category |> Category.alphabetical()
    query = from c in query, select: c.name
    assert Repo.all(query) == ~w(action background comedy)
  end

end