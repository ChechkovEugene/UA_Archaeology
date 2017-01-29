defmodule UaArchaeology.FindTest do
  use UaArchaeology.ModelCase

  alias UaArchaeology.Find

  @valid_attrs %{title: "some content", topo: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Find.changeset(%Find{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Find.changeset(%Find{}, @invalid_attrs)
    refute changeset.valid?
  end
end
