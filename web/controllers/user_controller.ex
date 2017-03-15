defmodule UaArchaeology.UserController do
  use UaArchaeology.Web, :controller

  alias UaArchaeology.User
  alias UaArchaeology.Role

  plug :scrub_params, "user" when action in [:create, :update]
  # plug :authorize_admin when action in [:new, :create]
  plug :authorize_user when action in [:edit, :update, :delete]

  defp authorize_user(conn, _) do
    user = get_session(conn, :current_user)
    if user && (Integer.to_string(user.id) == conn.params["id"] ||
      UaArchaeology.RoleChecker.is_admin?(user)) do
      conn
    else
      conn
      |> put_flash(:error, "Ви не авторизовані для зміни цього користувача!")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end

  defp authorize_admin(conn, _) do
    user = get_session(conn, :current_user)
    if user && UaArchaeology.RoleChecker.is_admin?(user) do
      conn
    else
      conn
      |> put_flash(:error,
        "Ви не авторизовані для створення нових користувачів!")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    roles = Repo.all(Role)
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset, roles: roles)
  end

  def create(conn, %{"user" => user_params}) do
    roles = Repo.all(Role)
    case Map.has_key?(user_params, "role_id") do
      true ->
        IO.puts "True"
        changeset = User.changeset(%User{}, user_params)
      _ ->
      user_role_name = "User Role"
      case Repo.one(from r in Role, where: r.name == ^user_role_name) do
        nil ->
          changeset = User.changeset(%User{}, user_params)
        role ->
          user_params = Map.put(user_params, "role_id", role.id)
          changeset = User.changeset(%User{}, user_params)
      end
    end

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Користувач успішно створений!")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, roles: roles)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    roles = Repo.all(Role)
    user = Repo.get!(User, id)
    changeset = User.changeset(user)
    render(conn, "edit.html", user: user, changeset: changeset, roles: roles)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    roles = Repo.all(Role)
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Користувача було успішно змінено.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset, roles: roles)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    conn
    |> put_flash(:info, "Користувача було успішно видалено.")
    |> redirect(to: user_path(conn, :index))
  end
end
