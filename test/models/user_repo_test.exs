defmodule UserRepoTest do
  use Rumbl.ModelCase

  alias Rumbl.User

  @valid_attrs %{name: "Sharkey Anchorbottom", username: "sharkey"}

  test "converts unique_constraint on username to error" do
    insert_user(username: "gristle")
    attrs = Map.put(@valid_attrs, :username, "gristle")
    changeset = User.changeset(%User{}, attrs)

    assert {:error, changeset} = Repo.insert(changeset)
    assert {:username, {"has already been taken", []}} in changeset.errors
  end
  
end