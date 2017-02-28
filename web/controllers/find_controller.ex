defmodule UaArchaeology.FindController do
  use UaArchaeology.Web, :controller

  alias UaArchaeology.Find

  plug :scrub_params, "find" when action in [:create, :update]
  plug :assign_user
  # plug :assign_user_nullable when action in [:index]
  plug :authorize_user when action in [:new, :create, :update, :edit, :delete]
  # plug :set_authorization_flag when action in [:show]

  def index(conn, _params) do
    # finds = Repo.all(assoc(conn.assigns[:user], :finds))
    finds = Repo.all(Find)
    render(conn, "index.html", finds: finds)
  end

  def new(conn, _params) do
    changeset = conn.assigns[:user]
      |> build_assoc(:finds)
      |> Find.changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"find" => find_params}) do
    changeset = conn.assigns[:user]
      |> build_assoc(:finds)
      |> Find.changeset(find_params)

    case Repo.insert(changeset) do
      {:ok, _find} ->
        conn
        |> put_flash(:info, "Археологічна пам'ятка успішно створена!")
        |> redirect(to: user_find_path(conn, :index, conn.assigns[:user]))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    find = Repo.get!(Find, id)
    # find = Repo.get!(assoc(conn.assigns[:user], :finds), id)
    render(conn, "show.html", find: find)
  end

  def edit(conn, %{"id" => id}) do
    find = Repo.get!(assoc(conn.assigns[:user], :finds), id)
    changeset = Find.changeset(find)
    render(conn, "edit.html", find: find, changeset: changeset)
  end

  def update(conn, %{"id" => id, "find" => find_params}) do
    find = Repo.get!(assoc(conn.assigns[:user], :finds), id)
    changeset = Find.changeset(find, find_params)

    case Repo.update(changeset) do
      {:ok, find} ->
        conn
        |> put_flash(:info, "Археологічна пам'ятка успішно оновлена.")
        |> redirect(to: user_find_path(conn, :show, conn.assigns[:user], find))
      {:error, changeset} ->
        render(conn, "edit.html", find: find, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    find = Repo.get!(assoc(conn.assigns[:user], :find), id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(find)

    conn
    |> put_flash(:info, "Археологічна пам'ятка успішно видалена.")
    |> redirect(to: user_find_path(conn, :index, conn.assigns[:user]))
  end

  defp assign_user(conn, _opts) do
    case conn.params do
      %{"user_id" => "-1"} ->
        assign(conn, :user, nil)
      %{"user_id" => user_id} ->
        case Repo.get(UaArchaeology.User, user_id) do
          nil  -> invalid_user(conn)
          user -> assign(conn, :user, user)
        end
      _ ->
        invalid_user(conn)
    end
  end

  defp invalid_user(conn) do
    conn
    |> put_flash(:error, "Невірний користувач!")
    |> redirect(to: page_path(conn, :index))
    |> halt
  end

  defp authorize_user(conn, _opts) do
    if is_authorized_user?(conn) do
      conn
    else
      conn
      |> put_flash(:error, "Ви не авторизовані для редагування цієї пам'ятки!")
      |> redirect(to: page_path(conn, :index))
      |> halt
    end
  end

  defp set_authorization_flag(conn, _opts) do
    assign(conn, :author_or_admin, is_authorized_user?(conn))
  end

  defp is_authorized_user?(conn) do
    user = get_session(conn, :current_user)
    (user && (Integer.to_string(user.id) == conn.params["user_id"] || UaArchaeology.RoleChecker.is_admin?(user)))
  end
end
