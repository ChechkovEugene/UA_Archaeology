defmodule UaArchaeology.PublicationTest do
  use UaArchaeology.ModelCase

  alias UaArchaeology.Publication

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Publication.changeset(%Publication{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Publication.changeset(%Publication{}, @invalid_attrs)
    refute changeset.valid?
  end
end
