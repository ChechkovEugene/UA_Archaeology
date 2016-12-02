defmodule UaArchaeology.ConditionControllerTest do
  use UaArchaeology.ConnCase

  alias UaArchaeology.Condition
  alias UaArchaeology.TestHelper
  import UaArchaeology.Factory

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup do
    role = insert(:role)
    user = insert(:user, role: role)
    condition = insert(:condition, user: user)
    conn = build_conn() |> login_user(user)
    {:ok, conn: conn, user: user, role: role, condition: condition}
  end

  defp login_user(conn, user) do
    post conn, session_path(conn, :create),
      user: %{username: user.username, password: user.password}
  end

  test "lists all entries on index", %{conn: conn, user: user} do
    conn = get conn, user_condition_path(conn, :index, user)
    assert html_response(conn, 200) =~ "Listing conditions"
  end

  test "renders form for new resources", %{conn: conn, user: user} do
    conn = get conn, user_condition_path(conn, :new, user)
    assert html_response(conn, 200) =~ "New condition"
  end

  test "creates resource and redirects when data is valid",
    %{conn: conn, user: user} do
    conn = post conn, user_condition_path(conn, :create, user),
      condition: @valid_attrs
    assert redirected_to(conn) == user_condition_path(conn, :index, user)
    assert Repo.get_by(Condition, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid",
    %{conn: conn, user: user} do
    conn = post conn, user_condition_path(conn, :create, user),
      condition: @invalid_attrs
    assert html_response(conn, 200) =~ "New condition"
  end

  test "shows chosen resource", %{conn: conn, user: user} do
    condition = Repo.insert! %Condition{}
    conn = get conn, user_condition_path(conn, :show, user, condition)
    assert html_response(conn, 200) =~ "Show condition"
  end

  test "renders page not found when id is nonexistent",
    %{conn: conn, user: user} do
      assert_raise Ecto.NoResultsError, fn ->
        get conn, user_condition_path(conn, :show, user, -1)
      end
  end

  test "renders form for editing chosen resource",
    %{conn: conn, user: user, condition: condition} do
      conn = get conn, user_condition_path(conn, :edit, user, condition)
      assert html_response(conn, 200) =~ "Edit condition"
  end

  test "updates chosen resource and redirects when data is valid",
    %{conn: conn, user: user, condition: condition} do
        conn = put conn, user_condition_path(conn, :update, user, condition),
          condition: @valid_attrs
        assert redirected_to(conn) == user_condition_path(conn, :show, user,
          condition)
        assert Repo.get_by(Condition, @valid_attrs)
    end

  test "does not update chosen resource and renders errors when data is invalid",
    %{conn: conn, user: user, condition: condition} do
      conn = put conn, user_condition_path(conn, :update, user, condition),
        condition: %{"name" => nil}
      assert html_response(conn, 200) =~ "Edit condition"
  end

  test "deletes chosen resource", %{conn: conn, user: user,
    condition: condition} do
    conn = delete conn, user_condition_path(conn, :delete, user, condition)
    assert redirected_to(conn) == user_condition_path(conn, :index, user)
    refute Repo.get(Condition, condition.id)
  end

  test "redirects when trying to edit a condition for a different user",
    %{conn: conn, role: role, condition: condition} do
      {:ok, other_user} = TestHelper.create_user(role,
        %{email: "test2@test.com", username: "test2", password: "test",
        password_confirmation: "test"})
      conn = get conn, user_condition_path(conn, :edit, other_user, condition)
      assert get_flash(conn, :error) ==
         "Ви не авторизовані для редагування цього стану!"
      assert redirected_to(conn) == page_path(conn, :index)
      assert conn.halted
  end

  test "redirects when trying to delete an condition for a different user",
    %{conn: conn, role: role, condition: condition} do
      {:ok, other_user} = TestHelper.create_user(role,
        %{email: "test2@test.com", username: "test2", password: "test",
         password_confirmation: "test"})
      conn = delete conn, user_condition_path(conn, :delete, other_user,
        condition)
      assert get_flash(conn, :error) ==
        "Ви не авторизовані для редагування цього стану!"
      assert redirected_to(conn) == page_path(conn, :index)
      assert conn.halted
  end

  test "renders form for editing chosen resource when logged in as admin",
    %{conn: conn, user: user, condition: condition} do
      {:ok, role}  = TestHelper.create_role(%{name: "Admin", admin: true})
      {:ok, admin} = TestHelper.create_user(role, %{username: "admin",
        email: "admin@test.com", password: "test",
        password_confirmation: "test"})
      conn =
      login_user(conn, admin)
      |> get(user_condition_path(conn, :edit, user, condition))
      assert html_response(conn, 200) =~ "Edit condition"
  end

  test "updates chosen resource and redirects when data is valid when
    logged in as admin", %{conn: conn, user: user, condition: condition} do
      {:ok, role}  = TestHelper.create_role(%{name: "Admin", admin: true})
      {:ok, admin} = TestHelper.create_user(role, %{username: "admin",
        email: "admin@test.com", password: "test", password_confirmation: "test"})
      conn =
      login_user(conn, admin)
      |> put(user_condition_path(conn, :update, user, condition),
        condition: @valid_attrs)
      assert redirected_to(conn) == user_condition_path(conn, :show, user,
        condition)
      assert Repo.get_by(Condition, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is
    invalid when logged in as admin", %{conn: conn, user: user,
     condition: condition} do
       {:ok, role}  = TestHelper.create_role(%{name: "Admin", admin: true})
       {:ok, admin} = TestHelper.create_user(role, %{username: "admin",
        email: "admin@test.com", password: "test", password_confirmation: "test"})
          conn =
          login_user(conn, admin)
          |> put(user_condition_path(conn, :update, user, condition),
            condition: %{"title" => nil})
          assert html_response(conn, 200) =~ "Edit condition"
  end

  test "deletes chosen resource when logged in as admin",
    %{conn: conn, user: user, condition: condition} do
      {:ok, role}  = TestHelper.create_role(%{name: "Admin", admin: true})
      {:ok, admin} = TestHelper.create_user(role,
       %{username: "admin", email: "admin@test.com", password: "test",
       password_confirmation: "test"})
        conn =
        login_user(conn, admin)
        |> delete(user_condition_path(conn, :delete, user, condition))
        assert redirected_to(conn) == user_condition_path(conn, :index, user)
        refute Repo.get(Condition, condition.id)
  end
end
