defmodule UaArchaeology.CultureControllerTest do
  use UaArchaeology.ConnCase

  alias UaArchaeology.Culture
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, culture_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing cultures"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, culture_path(conn, :new)
    assert html_response(conn, 200) =~ "New culture"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, culture_path(conn, :create), culture: @valid_attrs
    assert redirected_to(conn) == culture_path(conn, :index)
    assert Repo.get_by(Culture, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, culture_path(conn, :create), culture: @invalid_attrs
    assert html_response(conn, 200) =~ "New culture"
  end

  test "shows chosen resource", %{conn: conn} do
    culture = Repo.insert! %Culture{}
    conn = get conn, culture_path(conn, :show, culture)
    assert html_response(conn, 200) =~ "Show culture"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, culture_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    culture = Repo.insert! %Culture{}
    conn = get conn, culture_path(conn, :edit, culture)
    assert html_response(conn, 200) =~ "Edit culture"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    culture = Repo.insert! %Culture{}
    conn = put conn, culture_path(conn, :update, culture), culture: @valid_attrs
    assert redirected_to(conn) == culture_path(conn, :show, culture)
    assert Repo.get_by(Culture, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    culture = Repo.insert! %Culture{}
    conn = put conn, culture_path(conn, :update, culture), culture: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit culture"
  end

  test "deletes chosen resource", %{conn: conn} do
    culture = Repo.insert! %Culture{}
    conn = delete conn, culture_path(conn, :delete, culture)
    assert redirected_to(conn) == culture_path(conn, :index)
    refute Repo.get(Culture, culture.id)
  end
end
