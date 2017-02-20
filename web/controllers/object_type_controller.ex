defmodule UaArchaeology.ObjectTypeController do
  use UaArchaeology.Web, :controller

  alias UaArchaeology.ObjectType

  plug :scrub_params, "object_type" when action in [:create, :update]
  plug :assign_user
  plug :authorize_user when action in [:new, :create, :update, :edit, :delete]

  def index(conn, _params) do
    object_types = Repo.all(ObjectType)
    # object_types = Repo.all(assoc(conn.assigns[:user], :object_types))
    render(conn, "index.html", object_types: object_types)
  end

  def new(conn, _params) do
    changeset =
      conn.assigns[:user]
      |> build_assoc(:object_types)
      |> ObjectType.changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"object_type" => object_type_params}) do
    changeset =
      conn.assigns[:user]
      |> build_assoc(:object_types)
      |> ObjectType.changeset(object_type_params)

    case Repo.insert(changeset) do
      {:ok, _object_type} ->
        conn
        |> put_flash(:info, "Тип об'єктів успішно створений!")
        |> redirect(to: user_object_type_path(conn, :index, conn.assigns[:user]))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    object_type = Repo.get!(ObjectType, id)
    # object_type = Repo.get!(assoc(conn.assigns[:user], :object_types), id)
    render(conn, "show.html", object_type: object_type)
  end

  def edit(conn, %{"id" => id}) do
    object_type = Repo.get!(assoc(conn.assigns[:user], :object_types), id)
    changeset = ObjectType.changeset(object_type)
    render(conn, "edit.html", object_type: object_type, changeset: changeset)
  end

  def update(conn, %{"id" => id, "object_type" => object_type_params}) do
    object_type = Repo.get!(assoc(conn.assigns[:user], :object_types), id)
    changeset = ObjectType.changeset(object_type, object_type_params)

    case Repo.update(changeset) do
      {:ok, object_type} ->
        conn
        |> put_flash(:info, "Тип об'єктів було успішно змінено.")
        |> redirect(to: user_object_type_path(conn, :show, conn.assigns[:user],
          object_type))
      {:error, changeset} ->
        render(conn, "edit.html", object_type: object_type, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    object_type = Repo.get!(assoc(conn.assigns[:user], :object_types), id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(object_type)

    conn
    |> put_flash(:info, "Тип об'єктів було успішно видалено.")
    |> redirect(to: user_object_type_path(conn, :index, conn.assigns[:user]))
  end

  defp assign_user(conn, _opts) do
    case conn.params do
      %{"user_id" => user_id} ->
        case Repo.get(UaArchaeology.User, user_id) do
          nil  -> invalid_user(conn)
          user -> assign(conn, :user, user)
        end
      _ -> invalid_user(conn)
    end
  end

  defp invalid_user(conn) do
    conn
    |> put_flash(:error, "Невірний користувач!")
    |> redirect(to: page_path(conn, :index))
    |> halt
  end

  defp authorize_user(conn, _opts) do
    user = get_session(conn, :current_user)
    if user && Integer.to_string(user.id) == conn.params["user_id"] do
      conn
    else
      conn
      |> put_flash(:error, "Ви не авторизовані для редагування цього типу
      об'єктів!")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end
end
