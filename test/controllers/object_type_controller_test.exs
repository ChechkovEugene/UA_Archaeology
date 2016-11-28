defmodule UaArchaeology.ObjectTypeControllerTest do
  use UaArchaeology.ConnCase

  alias UaArchaeology.ObjectType
  alias UaArchaeology.TestHelper
  import UaArchaeology.Factory

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup do
    role = insert(:role)
    user = insert(:user, role: role)
    object_type = insert(:object_type, user: user)
    conn = build_conn() |> login_user(user)
    {:ok, conn: conn, user: user, role: role, object_type: object_type}
  end

  defp login_user(conn, user) do
    post conn, session_path(conn, :create),
      user: %{username: user.username, password: user.password}
  end

  test "lists all entries on index", %{conn: conn, user: user} do
    conn = get conn, user_object_type_path(conn, :index, user)
    assert html_response(conn, 200) =~ "Listing object types"
  end

  test "renders form for new resources", %{conn: conn, user: user} do
    conn = get conn, user_object_type_path(conn, :new, user)
    assert html_response(conn, 200) =~ "New object type"
  end

  test "creates resource and redirects when data is valid",
    %{conn: conn, user: user} do
    conn = post conn, user_object_type_path(conn, :create, user),
      object_type: @valid_attrs
    assert redirected_to(conn) == user_object_type_path(conn, :index, user)
    assert Repo.get_by(ObjectType, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid",
    %{conn: conn, user: user} do
    conn = post conn, user_object_type_path(conn, :create, user),
      object_type: @invalid_attrs
    assert html_response(conn, 200) =~ "New object type"
  end

  test "shows chosen resource", %{conn: conn, user: user} do
    object_type = Repo.insert! %ObjectType{}
    conn = get conn, user_object_type_path(conn, :show, user, object_type)
    assert html_response(conn, 200) =~ "Show object type"
  end

  test "renders page not found when id is nonexistent",
    %{conn: conn, user: user} do
      assert_raise Ecto.NoResultsError, fn ->
        get conn, user_object_type_path(conn, :show, user, -1)
      end
  end

  test "renders form for editing chosen resource",
    %{conn: conn, user: user, object_type: object_type} do
      conn = get conn, user_object_type_path(conn, :edit, user, object_type)
      assert html_response(conn, 200) =~ "Edit object type"
  end

  test "updates chosen resource and redirects when data is valid",
    %{conn: conn, user: user, object_type: object_type} do
        conn = put conn, user_object_type_path(conn, :update, user, object_type),
          object_type: @valid_attrs
        assert redirected_to(conn) == user_object_type_path(conn, :show, user,
          object_type)
        assert Repo.get_by(ObjectType, @valid_attrs)
    end

  test "does not update chosen resource and renders errors when data is invalid",
    %{conn: conn, user: user, object_type: object_type} do
      conn = put conn, user_object_type_path(conn, :update, user, object_type),
        object_type: %{"name" => nil}
      assert html_response(conn, 200) =~ "Edit object type"
  end

  test "deletes chosen resource", %{conn: conn, user: user,
    object_type: object_type} do
    conn = delete conn, user_object_type_path(conn, :delete, user, object_type)
    assert redirected_to(conn) == user_object_type_path(conn, :index, user)
    refute Repo.get(ObjectType, object_type.id)
  end

  test "redirects when trying to edit a object_type for a different user",
    %{conn: conn, role: role, object_type: object_type} do
      {:ok, other_user} = TestHelper.create_user(role,
        %{email: "test2@test.com", username: "test2", password: "test",
        password_confirmation: "test"})
      conn = get conn, user_object_type_path(conn, :edit, other_user, object_type)
      assert get_flash(conn, :error) ==
         "Ви не авторизовані для редагування цього типу об'єкту!"
      assert redirected_to(conn) == page_path(conn, :index)
      assert conn.halted
  end

  test "redirects when trying to delete an object type for a different user",
    %{conn: conn, role: role, object_type: object_type} do
      {:ok, other_user} = TestHelper.create_user(role,
        %{email: "test2@test.com", username: "test2", password: "test",
         password_confirmation: "test"})
      conn = delete conn, user_object_type_path(conn, :delete, other_user,
        object_type)
      assert get_flash(conn, :error) ==
        "Ви не авторизовані для редагування цього типу об'єкту!"
      assert redirected_to(conn) == page_path(conn, :index)
      assert conn.halted
  end

  test "renders form for editing chosen resource when logged in as admin",
    %{conn: conn, user: user, object_type: object_type} do
      {:ok, role}  = TestHelper.create_role(%{name: "Admin", admin: true})
      {:ok, admin} = TestHelper.create_user(role, %{username: "admin",
        email: "admin@test.com", password: "test",
        password_confirmation: "test"})
      conn =
      login_user(conn, admin)
      |> get(user_object_type_path(conn, :edit, user, object_type))
      assert html_response(conn, 200) =~ "Edit object type"
  end

  test "updates chosen resource and redirects when data is valid when
    logged in as admin", %{conn: conn, user: user, object_type: object_type} do
      {:ok, role}  = TestHelper.create_role(%{name: "Admin", admin: true})
      {:ok, admin} = TestHelper.create_user(role, %{username: "admin",
        email: "admin@test.com", password: "test", password_confirmation: "test"})
      conn =
      login_user(conn, admin)
      |> put(user_object_type_path(conn, :update, user, object_type),
        object_type: @valid_attrs)
      assert redirected_to(conn) == user_object_type_path(conn, :show, user,
        object_type)
      assert Repo.get_by(ObjectType, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is
    invalid when logged in as admin", %{conn: conn, user: user,
     object_type: object_type} do
       {:ok, role}  = TestHelper.create_role(%{name: "Admin", admin: true})
       {:ok, admin} = TestHelper.create_user(role, %{username: "admin",
        email: "admin@test.com", password: "test", password_confirmation: "test"})
          conn =
          login_user(conn, admin)
          |> put(user_object_type_path(conn, :update, user, object_type),
            object_type: %{"title" => nil})
          assert html_response(conn, 200) =~ "Edit object type"
  end

  test "deletes chosen resource when logged in as admin",
    %{conn: conn, user: user, object_type: object_type} do
      {:ok, role}  = TestHelper.create_role(%{name: "Admin", admin: true})
      {:ok, admin} = TestHelper.create_user(role,
       %{username: "admin", email: "admin@test.com", password: "test",
       password_confirmation: "test"})
        conn =
        login_user(conn, admin)
        |> delete(user_object_type_path(conn, :delete, user, object_type))
        assert redirected_to(conn) == user_object_type_path(conn, :index, user)
        refute Repo.get(ObjectType, object_type.id)
  end
end
