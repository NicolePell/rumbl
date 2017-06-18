defmodule Rumbl.UserTest do
  use Rumbl.ModelCase, async: true

  alias Rumbl.User

  @valid_attrs %{name: "Sharkey Anchorbottom", username: "sharkey", password: "secret"}
  @invalid_attrs %{}

  describe "changesets" do
    test "changeset with valid attributes" do
      changeset = User.changeset(%User{}, @valid_attrs)
      assert changeset.valid?
    end

    test "changeset with invalid attributes" do
      changeset = User.changeset(%User{}, @invalid_attrs)
      refute changeset.valid?
    end

    test "changeset does not accept long usernames" do
      attrs = Map.put(@valid_attrs, :username, String.duplicate("a", 30))

      assert {:username, "should be at most 20 character(s)"} in
            errors_on(%User{}, attrs)
    end
  end

  describe "password policies" do
    test "registration_changeset errors when password is not long enough" do
      attrs = Map.put(@valid_attrs, :password, "12345")
      changeset = User.registration_changeset(%User{}, attrs)

      assert {:password, {"should be at least %{count} character(s)",
          [count: 6, validation: :length, min: 6]}} in changeset.errors
    end

    test "registration_changeset successfully hashes password with valid attributes" do
      attrs = Map.put(@valid_attrs, :password, "123456")
      changeset = User.registration_changeset(%User{}, attrs)
      %{password: pass, password_hash: pass_hash} = changeset.changes

      assert changeset.valid?
      assert pass_hash
      assert Comeonin.Bcrypt.checkpw(pass, pass_hash)
    end
  end

end