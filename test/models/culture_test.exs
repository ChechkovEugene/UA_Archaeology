defmodule UaArchaeology.CultureTest do
  use UaArchaeology.ModelCase

  alias UaArchaeology.Culture

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Culture.changeset(%Culture{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Culture.changeset(%Culture{}, @invalid_attrs)
    refute changeset.valid?
  end
end
