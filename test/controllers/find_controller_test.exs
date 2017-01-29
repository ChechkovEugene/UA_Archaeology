defmodule UaArchaeology.FindControllerTest do
  use UaArchaeology.ConnCase

  alias UaArchaeology.Find
  @valid_attrs %{title: "some content", topo: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, find_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing finds"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, find_path(conn, :new)
    assert html_response(conn, 200) =~ "New find"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, find_path(conn, :create), find: @valid_attrs
    assert redirected_to(conn) == find_path(conn, :index)
    assert Repo.get_by(Find, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, find_path(conn, :create), find: @invalid_attrs
    assert html_response(conn, 200) =~ "New find"
  end

  test "shows chosen resource", %{conn: conn} do
    find = Repo.insert! %Find{}
    conn = get conn, find_path(conn, :show, find)
    assert html_response(conn, 200) =~ "Show find"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, find_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    find = Repo.insert! %Find{}
    conn = get conn, find_path(conn, :edit, find)
    assert html_response(conn, 200) =~ "Edit find"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    find = Repo.insert! %Find{}
    conn = put conn, find_path(conn, :update, find), find: @valid_attrs
    assert redirected_to(conn) == find_path(conn, :show, find)
    assert Repo.get_by(Find, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    find = Repo.insert! %Find{}
    conn = put conn, find_path(conn, :update, find), find: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit find"
  end

  test "deletes chosen resource", %{conn: conn} do
    find = Repo.insert! %Find{}
    conn = delete conn, find_path(conn, :delete, find)
    assert redirected_to(conn) == find_path(conn, :index)
    refute Repo.get(Find, find.id)
  end
end
