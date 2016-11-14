defmodule UaArchaeology.CultureControllerTest do
  use UaArchaeology.ConnCase

  alias UaArchaeology.Culture
  alias UaArchaeology.TestHelper
  import UaArchaeology.Factory

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup do
    role = insert(:role)
    user = insert(:user, role: role)
    culture = insert(:culture, user: user)
    conn = build_conn() |> login_user(user)
    {:ok, conn: conn, user: user, role: role, culture: culture}
  end

  defp login_user(conn, user) do
    post conn, session_path(conn, :create),
      user: %{username: user.username, password: user.password}
  end

  test "lists all entries on index", %{conn: conn, user: user} do
    conn = get conn, user_culture_path(conn, :index, user)
    assert html_response(conn, 200) =~ "Listing cultures"
  end

  test "renders form for new resources", %{conn: conn, user: user} do
    conn = get conn, user_culture_path(conn, :new, user)
    assert html_response(conn, 200) =~ "New culture"
  end

  test "creates resource and redirects when data is valid",
    %{conn: conn, user: user} do
    conn = post conn, user_culture_path(conn, :create, user), culture: @valid_attrs
    assert redirected_to(conn) == user_culture_path(conn, :index, user)
    assert Repo.get_by(Culture, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid",
    %{conn: conn, user: user} do
    conn = post conn, user_culture_path(conn, :create, user), culture: @invalid_attrs
    assert html_response(conn, 200) =~ "New culture"
  end

  test "shows chosen resource", %{conn: conn, user: user} do
    culture = Repo.insert! %Culture{}
    conn = get conn, user_culture_path(conn, :show, user, culture)
    assert html_response(conn, 200) =~ "Show culture"
  end

  test "renders page not found when id is nonexistent",
    %{conn: conn, user: user} do
      assert_raise Ecto.NoResultsError, fn ->
        get conn, user_culture_path(conn, :show, user, -1)
      end
  end

  test "renders form for editing chosen resource",
    %{conn: conn, user: user, culture: culture} do
      conn = get conn, user_culture_path(conn, :edit, user, culture)
      assert html_response(conn, 200) =~ "Edit culture"
  end

  test "updates chosen resource and redirects when data is valid",
    %{conn: conn, user: user, culture: culture} do
        conn = put conn, user_culture_path(conn, :update, user, culture),
          culture: @valid_attrs
        assert redirected_to(conn) == user_culture_path(conn, :show, user, culture)
        assert Repo.get_by(Culture, @valid_attrs)
    end

  test "does not update chosen resource and renders errors when data is invalid",
    %{conn: conn, user: user, culture: culture} do
      conn = put conn, user_culture_path(conn, :update, user, culture), culture: %{"name" => nil}
      assert html_response(conn, 200) =~ "Edit culture"
  end

  test "deletes chosen resource", %{conn: conn, user: user, culture: culture} do
    conn = delete conn, user_culture_path(conn, :delete, user, culture)
    assert redirected_to(conn) == user_culture_path(conn, :index, user)
    refute Repo.get(Culture, culture.id)
  end

  test "redirects when trying to edit a culture for a different user",
    %{conn: conn, role: role, culture: culture} do
      {:ok, other_user} = TestHelper.create_user(role,
        %{email: "test2@test.com", username: "test2", password: "test",
        password_confirmation: "test"})
      conn = get conn, user_culture_path(conn, :edit, other_user, culture)
      assert get_flash(conn, :error) ==
         "Ви не авторизовані для редагування цієї культури!"
      assert redirected_to(conn) == page_path(conn, :index)
      assert conn.halted
  end

  test "redirects when trying to delete a culture for a different user",
    %{conn: conn, role: role, culture: culture} do
      {:ok, other_user} = TestHelper.create_user(role,
        %{email: "test2@test.com", username: "test2", password: "test",
         password_confirmation: "test"})
      conn = delete conn, user_culture_path(conn, :delete, other_user, culture)
      assert get_flash(conn, :error) ==
        "Ви не авторизовані для редагування цієї культури!"
      assert redirected_to(conn) == page_path(conn, :index)
      assert conn.halted
  end

  test "renders form for editing chosen resource when logged in as admin",
    %{conn: conn, user: user, culture: culture} do
      {:ok, role}  = TestHelper.create_role(%{name: "Admin", admin: true})
      {:ok, admin} = TestHelper.create_user(role, %{username: "admin",
        email: "admin@test.com", password: "test",
        password_confirmation: "test"})
      conn =
      login_user(conn, admin)
      |> get(user_culture_path(conn, :edit, user, culture))
      assert html_response(conn, 200) =~ "Edit post"
  end

  test "updates chosen resource and redirects when data is valid when
    logged in as admin", %{conn: conn, user: user, culture: culture} do
      {:ok, role}  = TestHelper.create_role(%{name: "Admin", admin: true})
      {:ok, admin} = TestHelper.create_user(role, %{username: "admin",
        email: "admin@test.com", password: "test", password_confirmation: "test"})
      conn =
      login_user(conn, admin)
      |> put(user_culture_path(conn, :update, user, culture), culture: @valid_attrs)
      assert redirected_to(conn) == user_culture_path(conn, :show, user, culture)
      assert Repo.get_by(Culture, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is
    invalid when logged in as admin", %{conn: conn, user: user,
     culture: culture} do
       {:ok, role}  = TestHelper.create_role(%{name: "Admin", admin: true})
       {:ok, admin} = TestHelper.create_user(role, %{username: "admin",
        email: "admin@test.com", password: "test", password_confirmation: "test"})
          conn =
          login_user(conn, admin)
          |> put(user_culture_path(conn, :update, user, culture),
            culture: %{"title" => nil})
          assert html_response(conn, 200) =~ "Edit culture"
  end

  test "deletes chosen resource when logged in as admin",
    %{conn: conn, user: user, culture: culture} do
      {:ok, role}  = TestHelper.create_role(%{name: "Admin", admin: true})
      {:ok, admin} = TestHelper.create_user(role,
       %{username: "admin", email: "admin@test.com", password: "test",
       password_confirmation: "test"})
        conn =
        login_user(conn, admin)
        |> delete(user_culture_path(conn, :delete, user, culture))
        assert redirected_to(conn) == user_culture_path(conn, :index, user)
        refute Repo.get(Culture, culture.id)
  end
end
