defmodule UaArchaeology.ObjectTypeTest do
  use UaArchaeology.ModelCase

  alias UaArchaeology.ObjectType

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ObjectType.changeset(%ObjectType{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ObjectType.changeset(%ObjectType{}, @invalid_attrs)
    refute changeset.valid?
  end
end
