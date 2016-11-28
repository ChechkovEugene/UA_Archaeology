defmodule UaArchaeology.ResearchLevelControllerTest do
  use UaArchaeology.ConnCase

  alias UaArchaeology.ResearchLevel
  alias UaArchaeology.TestHelper
  import UaArchaeology.Factory

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup do
    role = insert(:role)
    user = insert(:user, role: role)
    research_level = insert(:research_level, user: user)
    conn = build_conn() |> login_user(user)
    {:ok, conn: conn, user: user, role: role, research_level: research_level}
  end

  defp login_user(conn, user) do
    post conn, session_path(conn, :create),
      user: %{username: user.username, password: user.password}
  end

  test "lists all entries on index", %{conn: conn, user: user} do
    conn = get conn, user_research_level_path(conn, :index, user)
    assert html_response(conn, 200) =~ "Listing research levels"
  end

  test "renders form for new resources", %{conn: conn, user: user} do
    conn = get conn, user_research_level_path(conn, :new, user)
    assert html_response(conn, 200) =~ "New research level"
  end

  test "creates resource and redirects when data is valid",
    %{conn: conn, user: user} do
    conn = post conn, user_research_level_path(conn, :create, user),
      research_level: @valid_attrs
    assert redirected_to(conn) == user_research_level_path(conn, :index, user)
    assert Repo.get_by(ResearchLevel, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid",
    %{conn: conn, user: user} do
    conn = post conn, user_research_level_path(conn, :create, user),
      research_level: @invalid_attrs
    assert html_response(conn, 200) =~ "New research level"
  end

  test "shows chosen resource", %{conn: conn, user: user} do
    research_level = Repo.insert! %ResearchLevel{}
    conn = get conn, user_research_level_path(conn, :show, user, research_level)
    assert html_response(conn, 200) =~ "Show research level"
  end

  test "renders page not found when id is nonexistent",
    %{conn: conn, user: user} do
      assert_raise Ecto.NoResultsError, fn ->
        get conn, user_research_level_path(conn, :show, user, -1)
      end
  end

  test "renders form for editing chosen resource",
    %{conn: conn, user: user, research_level: research_level} do
      conn = get conn, user_research_level_path(conn, :edit, user, research_level)
      assert html_response(conn, 200) =~ "Edit research level"
  end

  test "updates chosen resource and redirects when data is valid",
    %{conn: conn, user: user, research_level: research_level} do
        conn = put conn, user_research_level_path(conn, :update, user,
        research_level), research_level: @valid_attrs
        assert redirected_to(conn) == user_research_level_path(conn, :show, user,
          research_level)
        assert Repo.get_by(ResearchLevel, @valid_attrs)
    end

  test "does not update chosen resource and renders errors when data is invalid",
    %{conn: conn, user: user, research_level: research_level} do
      conn = put conn, user_research_level_path(conn, :update, user,
      research_level), research_level: %{"name" => nil}
      assert html_response(conn, 200) =~ "Edit research level"
  end

  test "deletes chosen resource", %{conn: conn, user: user,
    research_level: research_level} do
    conn = delete conn, user_research_level_path(conn, :delete, user,
      research_level)
    assert redirected_to(conn) == user_research_level_path(conn, :index, user)
    refute Repo.get(ResearchLevel, research_level.id)
  end

  test "redirects when trying to edit a research level for a different user",
    %{conn: conn, role: role, research_level: research_level} do
      {:ok, other_user} = TestHelper.create_user(role,
        %{email: "test2@test.com", username: "test2", password: "test",
        password_confirmation: "test"})
      conn = get conn, user_research_level_path(conn, :edit, other_user,
        research_level)
      assert get_flash(conn, :error) ==
         "Ви не авторизовані для редагування цього
           рівня археологічних досліджень!"
      assert redirected_to(conn) == page_path(conn, :index)
      assert conn.halted
  end

  test "redirects when trying to delete an research level for a different user",
    %{conn: conn, role: role, research_level: research_level} do
      {:ok, other_user} = TestHelper.create_user(role,
        %{email: "test2@test.com", username: "test2", password: "test",
         password_confirmation: "test"})
      conn = delete conn, user_research_level_path(conn, :delete, other_user,
        research_level)
      assert get_flash(conn, :error) ==
        "Ви не авторизовані для редагування цього
          рівня археологічних досліджень!"
      assert redirected_to(conn) == page_path(conn, :index)
      assert conn.halted
  end

  test "renders form for editing chosen resource when logged in as admin",
    %{conn: conn, user: user, research_level: research_level} do
      {:ok, role}  = TestHelper.create_role(%{name: "Admin", admin: true})
      {:ok, admin} = TestHelper.create_user(role, %{username: "admin",
        email: "admin@test.com", password: "test",
        password_confirmation: "test"})
      conn =
      login_user(conn, admin)
      |> get(user_research_level_path(conn, :edit, user, research_level))
      assert html_response(conn, 200) =~ "Edit research level"
  end

  test "updates chosen resource and redirects when data is valid when
    logged in as admin", %{conn: conn, user: user, research_level: research_level} do
      {:ok, role}  = TestHelper.create_role(%{name: "Admin", admin: true})
      {:ok, admin} = TestHelper.create_user(role, %{username: "admin",
        email: "admin@test.com", password: "test", password_confirmation: "test"})
      conn =
      login_user(conn, admin)
      |> put(user_research_level_path(conn, :update, user, research_level),
        object_type: @valid_attrs)
      assert redirected_to(conn) == user_research_level_path(conn, :show, user,
        research_level)
      assert Repo.get_by(ResearchLevel, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is
    invalid when logged in as admin", %{conn: conn, user: user,
     research_level: research_level} do
       {:ok, role}  = TestHelper.create_role(%{name: "Admin", admin: true})
       {:ok, admin} = TestHelper.create_user(role, %{username: "admin",
        email: "admin@test.com", password: "test", password_confirmation: "test"})
          conn =
          login_user(conn, admin)
          |> put(user_research_level_path(conn, :update, user, research_level),
            research_level: %{"title" => nil})
          assert html_response(conn, 200) =~ "Edit research level"
  end

  test "deletes chosen resource when logged in as admin",
    %{conn: conn, user: user, research_level: research_level} do
      {:ok, role}  = TestHelper.create_role(%{name: "Admin", admin: true})
      {:ok, admin} = TestHelper.create_user(role,
       %{username: "admin", email: "admin@test.com", password: "test",
       password_confirmation: "test"})
        conn =
        login_user(conn, admin)
        |> delete(user_research_level_path(conn, :delete, user, research_level))
        assert redirected_to(conn) == user_research_level_path(conn, :index, user)
        refute Repo.get(ResearchLevel, research_level.id)
  end
end
