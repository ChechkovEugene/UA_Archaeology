defmodule UaArchaeology.AuthorControllerTest do
  use UaArchaeology.ConnCase

  alias UaArchaeology.Author
  alias UaArchaeology.TestHelper
  import UaArchaeology.Factory

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup do
    role = insert(:role)
    user = insert(:user, role: role)
    author = insert(:author, user: user)
    conn = build_conn() |> login_user(user)
    {:ok, conn: conn, user: user, role: role, author: author}
  end

  defp login_user(conn, user) do
    post conn, session_path(conn, :create),
      user: %{username: user.username, password: user.password}
  end

  test "lists all entries on index", %{conn: conn, user: user} do
    conn = get conn, user_author_path(conn, :index, user)
    assert html_response(conn, 200) =~ "Listing authors"
  end

  test "renders form for new resources", %{conn: conn, user: user} do
    conn = get conn, user_author_path(conn, :new, user)
    assert html_response(conn, 200) =~ "New author"
  end

  test "creates resource and redirects when data is valid",
    %{conn: conn, user: user} do
    conn = post conn, user_author_path(conn, :create, user),
      author: @valid_attrs
    assert redirected_to(conn) == user_author_path(conn, :index, user)
    assert Repo.get_by(Author, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid",
    %{conn: conn, user: user} do
    conn = post conn, user_author_path(conn, :create, user),
      author: @invalid_attrs
    assert html_response(conn, 200) =~ "New author"
  end

  test "shows chosen resource", %{conn: conn, user: user} do
    author = Repo.insert! %Author{}
    conn = get conn, user_author_path(conn, :show, user, author)
    assert html_response(conn, 200) =~ "Show author"
  end

  test "renders page not found when id is nonexistent",
    %{conn: conn, user: user} do
      assert_raise Ecto.NoResultsError, fn ->
        get conn, user_author_path(conn, :show, user, -1)
      end
  end

  test "renders form for editing chosen resource",
    %{conn: conn, user: user, author: author} do
      conn = get conn, user_author_path(conn, :edit, user, author)
      assert html_response(conn, 200) =~ "Edit author"
  end

  test "updates chosen resource and redirects when data is valid",
    %{conn: conn, user: user, author: author} do
        conn = put conn, user_author_path(conn, :update, user, author),
          author: @valid_attrs
        assert redirected_to(conn) == user_author_path(conn, :show, user,
          author)
        assert Repo.get_by(Author, @valid_attrs)
    end

  test "does not update chosen resource and renders errors when data is invalid",
    %{conn: conn, user: user, author: author} do
      conn = put conn, user_author_path(conn, :update, user, author),
        author: %{"name" => nil}
      assert html_response(conn, 200) =~ "Edit author"
  end

  test "deletes chosen resource", %{conn: conn, user: user,
    author: author} do
    conn = delete conn, user_author_path(conn, :delete, user, author)
    assert redirected_to(conn) == user_author_path(conn, :index, user)
    refute Repo.get(Author, author.id)
  end

  test "redirects when trying to edit an author for a different user",
    %{conn: conn, role: role, author: author} do
      {:ok, other_user} = TestHelper.create_user(role,
        %{email: "test2@test.com", username: "test2", password: "test",
        password_confirmation: "test"})
      conn = get conn, user_author_path(conn, :edit, other_user, author)
      assert get_flash(conn, :error) ==
         "Ви не авторизовані для редагування цього автора!"
      assert redirected_to(conn) == page_path(conn, :index)
      assert conn.halted
  end

  test "redirects when trying to delete an author for a different user",
    %{conn: conn, role: role, author: author} do
      {:ok, other_user} = TestHelper.create_user(role,
        %{email: "test2@test.com", username: "test2", password: "test",
         password_confirmation: "test"})
      conn = delete conn, user_author_path(conn, :delete, other_user,
        author)
      assert get_flash(conn, :error) ==
        "Ви не авторизовані для редагування цього автора!"
      assert redirected_to(conn) == page_path(conn, :index)
      assert conn.halted
  end

  test "renders form for editing chosen resource when logged in as admin",
    %{conn: conn, user: user, author: author} do
      {:ok, role}  = TestHelper.create_role(%{name: "Admin", admin: true})
      {:ok, admin} = TestHelper.create_user(role, %{username: "admin",
        email: "admin@test.com", password: "test",
        password_confirmation: "test"})
      conn =
      login_user(conn, admin)
      |> get(user_author_path(conn, :edit, user, author))
      assert html_response(conn, 200) =~ "Edit author"
  end

  test "updates chosen resource and redirects when data is valid when
    logged in as admin", %{conn: conn, user: user, author: author} do
      {:ok, role}  = TestHelper.create_role(%{name: "Admin", admin: true})
      {:ok, admin} = TestHelper.create_user(role, %{username: "admin",
        email: "admin@test.com", password: "test", password_confirmation: "test"})
      conn =
      login_user(conn, admin)
      |> put(user_author_path(conn, :update, user, author),
        author: @valid_attrs)
      assert redirected_to(conn) == user_author_path(conn, :show, user,
        author)
      assert Repo.get_by(Author, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is
    invalid when logged in as admin", %{conn: conn, user: user,
     author: author} do
       {:ok, role}  = TestHelper.create_role(%{name: "Admin", admin: true})
       {:ok, admin} = TestHelper.create_user(role, %{username: "admin",
        email: "admin@test.com", password: "test", password_confirmation: "test"})
          conn =
          login_user(conn, admin)
          |> put(user_author_path(conn, :update, user, author),
            author: %{"title" => nil})
          assert html_response(conn, 200) =~ "Edit author"
  end

  test "deletes chosen resource when logged in as admin",
    %{conn: conn, user: user, author: author} do
      {:ok, role}  = TestHelper.create_role(%{name: "Admin", admin: true})
      {:ok, admin} = TestHelper.create_user(role,
       %{username: "admin", email: "admin@test.com", password: "test",
       password_confirmation: "test"})
        conn =
        login_user(conn, admin)
        |> delete(user_author_path(conn, :delete, user, author))
        assert redirected_to(conn) == user_author_path(conn, :index, user)
        refute Repo.get(Author, author.id)
  end
end
