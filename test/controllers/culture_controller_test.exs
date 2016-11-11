defmodule UaArchaeology.CultureControllerTest do
  use UaArchaeology.ConnCase

  alias UaArchaeology.Culture
  alias UaArchaeology.User

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup do
    {:ok, user} = create_user
    conn = build_conn()
    |> login_user(user)
    {:ok, conn: conn, user: user}
  end

  defp create_user do
    User.changeset(%User{}, %{email: "test@test.com", username: "test",
      password: "test", password_confirmation: "test"})
    |> Repo.insert
  end

  defp login_user(conn, user) do
    post conn, session_path(conn, :create), user: %{username: user.username,
      password: user.password}
  end

  defp build_culture(user) do
    changeset =
      user
      |> build_assoc(:cultures)
      |> Culture.changeset(@valid_attrs)
    Repo.insert!(changeset)
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
    %{conn: conn, user: user} do
      culture = build_culture(user)
      conn = get conn, user_culture_path(conn, :edit, user, culture)
      assert html_response(conn, 200) =~ "Edit culture"
  end

  test "updates chosen resource and redirects when data is valid",
    %{conn: conn, user: user} do
        culture = build_culture(user)
        conn = put conn, user_culture_path(conn, :update, user, culture),
          culture: @valid_attrs
        assert redirected_to(conn) == user_culture_path(conn, :show, user, culture)
        assert Repo.get_by(Culture, @valid_attrs)
    end

  test "does not update chosen resource and renders errors when data is invalid",
    %{conn: conn, user: user} do
      culture = build_culture(user)
      conn = put conn, user_culture_path(conn, :update, user, culture), culture: %{"name" => nil}
      assert html_response(conn, 200) =~ "Edit culture"
  end

  test "deletes chosen resource", %{conn: conn, user: user} do
    culture = build_culture(user)
    conn = delete conn, user_culture_path(conn, :delete, user, culture)
    assert redirected_to(conn) == user_culture_path(conn, :index, user)
    refute Repo.get(Culture, culture.id)
  end
end
