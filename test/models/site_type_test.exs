defmodule UaArchaeology.SiteTypeTest do
  use UaArchaeology.ModelCase

  alias UaArchaeology.SiteType

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = SiteType.changeset(%SiteType{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = SiteType.changeset(%SiteType{}, @invalid_attrs)
    refute changeset.valid?
  end
end
