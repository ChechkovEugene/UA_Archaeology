defmodule UaArchaeology.PublicationControllerTest do
  use UaArchaeology.ConnCase

  alias UaArchaeology.Publication
  alias UaArchaeology.TestHelper
  import UaArchaeology.Factory

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup do
    role = insert(:role)
    user = insert(:user, role: role)
    publication = insert(:publication, user: user)
    conn = build_conn() |> login_user(user)
    {:ok, conn: conn, user: user, role: role, publication: publication}
  end

  defp login_user(conn, user) do
    post conn, session_path(conn, :create),
      user: %{username: user.username, password: user.password}
  end

  test "lists all entries on index", %{conn: conn, user: user} do
    conn = get conn, user_publication_path(conn, :index, user)
    assert html_response(conn, 200) =~ "Listing publications"
  end

  test "renders form for new resources", %{conn: conn, user: user} do
    conn = get conn, user_publication_path(conn, :new, user)
    assert html_response(conn, 200) =~ "New publication"
  end

  test "creates resource and redirects when data is valid",
    %{conn: conn, user: user} do
    conn = post conn, user_publication_path(conn, :create, user),
      publication: @valid_attrs
    assert redirected_to(conn) == user_publication_path(conn, :index, user)
    assert Repo.get_by(Publication, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid",
    %{conn: conn, user: user} do
    conn = post conn, user_publication_path(conn, :create, user),
      publication: @invalid_attrs
    assert html_response(conn, 200) =~ "New publication"
  end

  test "shows chosen resource", %{conn: conn, user: user} do
    publication = Repo.insert! %Publication{}
    conn = get conn, user_publication_path(conn, :show, user, publication)
    assert html_response(conn, 200) =~ "Show publication"
  end

  test "renders page not found when id is nonexistent",
    %{conn: conn, user: user} do
      assert_raise Ecto.NoResultsError, fn ->
        get conn, user_publication_path(conn, :show, user, -1)
      end
  end

  test "renders form for editing chosen resource",
    %{conn: conn, user: user, publication: publication} do
      conn = get conn, user_publication_path(conn, :edit, user, publication)
      assert html_response(conn, 200) =~ "Edit publication"
  end

  test "updates chosen resource and redirects when data is valid",
    %{conn: conn, user: user, publication: publication} do
        conn = put conn, user_publication_path(conn, :update, user, publication),
          publication: @valid_attrs
        assert redirected_to(conn) == user_publication_path(conn, :show, user,
          publication)
        assert Repo.get_by(Publication, @valid_attrs)
    end

  test "does not update chosen resource and renders errors when data is invalid",
    %{conn: conn, user: user, publication: publication} do
      conn = put conn, user_publication_path(conn, :update, user, publication),
        publication: %{"name" => nil}
      assert html_response(conn, 200) =~ "Edit publication"
  end

  test "deletes chosen resource", %{conn: conn, user: user,
    publication: publication} do
    conn = delete conn, user_publication_path(conn, :delete, user, publication)
    assert redirected_to(conn) == user_publication_path(conn, :index, user)
    refute Repo.get(Publication, publication.id)
  end

  test "redirects when trying to edit a publication for a different user",
    %{conn: conn, role: role, publication: publication} do
      {:ok, other_user} = TestHelper.create_user(role,
        %{email: "test2@test.com", username: "test2", password: "test",
        password_confirmation: "test"})
      conn = get conn, user_publication_path(conn, :edit, other_user, publication)
      assert get_flash(conn, :error) ==
         "Ви не авторизовані для редагування цієї публікації!"
      assert redirected_to(conn) == page_path(conn, :index)
      assert conn.halted
  end

  test "redirects when trying to delete a publication for a different user",
    %{conn: conn, role: role, publication: publication} do
      {:ok, other_user} = TestHelper.create_user(role,
        %{email: "test2@test.com", username: "test2", password: "test",
         password_confirmation: "test"})
      conn = delete conn, user_publication_path(conn, :delete, other_user,
        publication)
      assert get_flash(conn, :error) ==
        "Ви не авторизовані для редагування цієї публікації!"
      assert redirected_to(conn) == page_path(conn, :index)
      assert conn.halted
  end

  test "renders form for editing chosen resource when logged in as admin",
    %{conn: conn, user: user, publication: publication} do
      {:ok, role}  = TestHelper.create_role(%{name: "Admin", admin: true})
      {:ok, admin} = TestHelper.create_user(role, %{username: "admin",
        email: "admin@test.com", password: "test",
        password_confirmation: "test"})
      conn =
      login_user(conn, admin)
      |> get(user_publication_path(conn, :edit, user, publication))
      assert html_response(conn, 200) =~ "Edit publication"
  end

  test "updates chosen resource and redirects when data is valid when
    logged in as admin", %{conn: conn, user: user, publication: publication} do
      {:ok, role}  = TestHelper.create_role(%{name: "Admin", admin: true})
      {:ok, admin} = TestHelper.create_user(role, %{username: "admin",
        email: "admin@test.com", password: "test", password_confirmation: "test"})
      conn =
      login_user(conn, admin)
      |> put(user_publication_path(conn, :update, user, publication),
        publication: @valid_attrs)
      assert redirected_to(conn) == user_publication_path(conn, :show, user,
        publication)
      assert Repo.get_by(Publication, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is
    invalid when logged in as admin", %{conn: conn, user: user,
     publication: publication} do
       {:ok, role}  = TestHelper.create_role(%{name: "Admin", admin: true})
       {:ok, admin} = TestHelper.create_user(role, %{username: "admin",
        email: "admin@test.com", password: "test", password_confirmation: "test"})
          conn =
          login_user(conn, admin)
          |> put(user_publication_path(conn, :update, user, publication),
            publication: %{"title" => nil})
          assert html_response(conn, 200) =~ "Edit publication"
  end

  test "deletes chosen resource when logged in as admin",
    %{conn: conn, user: user, publication: publication} do
      {:ok, role}  = TestHelper.create_role(%{name: "Admin", admin: true})
      {:ok, admin} = TestHelper.create_user(role,
       %{username: "admin", email: "admin@test.com", password: "test",
       password_confirmation: "test"})
        conn =
        login_user(conn, admin)
        |> delete(user_publication_path(conn, :delete, user, publication))
        assert redirected_to(conn) == user_publication_path(conn, :index, user)
        refute Repo.get(Publication, publication.id)
  end
end
