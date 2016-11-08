defmodule UaArchaeology.UserTest do
  use UaArchaeology.ModelCase

  alias UaArchaeology.User

  @valid_attrs %{email: "test.archaeo@gmail.com", password: "iddqdd",
    password_confirmation: "iddqdd", username: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "password digest value gets set to a hash" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert get_change(changeset, :password_digest) == "ABCDE"
  end
end
