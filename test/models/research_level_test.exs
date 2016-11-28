defmodule UaArchaeology.ResearchLevelTest do
  use UaArchaeology.ModelCase

  alias UaArchaeology.ResearchLevel

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ResearchLevel.changeset(%ResearchLevel{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ResearchLevel.changeset(%ResearchLevel{}, @invalid_attrs)
    refute changeset.valid?
  end
end
