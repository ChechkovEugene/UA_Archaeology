defmodule UaArchaeology.SiteTypeController do
  use UaArchaeology.Web, :controller

  alias UaArchaeology.SiteType

  plug :scrub_params, "site_type" when action in [:create, :update]
  plug :assign_user
  plug :authorize_user when action in [:new, :create, :update, :edit, :delete]

  def index(conn, _params) do
    site_types = Repo.all(SiteType)
    # site_types = Repo.all(assoc(conn.assigns[:user], :site_types))
    render(conn, "index.html", site_types: site_types)
  end

  def new(conn, _params) do
    changeset =
      conn.assigns[:user]
      |> build_assoc(:site_types)
      |> SiteType.changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"site_type" => site_type_params}) do
    changeset =
      conn.assigns[:user]
      |> build_assoc(:site_types)
      |> SiteType.changeset(site_type_params)

    case Repo.insert(changeset) do
      {:ok, _site_type} ->
        conn
        |> put_flash(:info, "Тип пам'яток успішно створений!")
        |> redirect(to: user_site_type_path(conn, :index, conn.assigns[:user]))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    site_type = Repo.get!(SiteType, id)
    # site_type = Repo.get!(assoc(conn.assigns[:user], :site_types), id)
    render(conn, "show.html", site_type: site_type)
  end

  def edit(conn, %{"id" => id}) do
    site_type = Repo.get!(assoc(conn.assigns[:user], :site_types), id)
    changeset = SiteType.changeset(site_type)
    render(conn, "edit.html", site_type: site_type, changeset: changeset)
  end

  def update(conn, %{"id" => id, "site_type" => site_type_params}) do
    site_type = Repo.get!(assoc(conn.assigns[:user], :site_types), id)
    changeset = SiteType.changeset(site_type, site_type_params)

    case Repo.update(changeset) do
      {:ok, site_type} ->
        conn
        |> put_flash(:info, "Тип пам'яток було успішно змінено.")
        |> redirect(to: user_site_type_path(conn, :show, conn.assigns[:user],
          site_type))
      {:error, changeset} ->
        render(conn, "edit.html", site_type: site_type, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    site_type = Repo.get!(assoc(conn.assigns[:user], :site_types), id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(site_type)

    conn
    |> put_flash(:info, "Тип пам'яток було успішно видалено.")
    |> redirect(to: user_site_type_path(conn, :index, conn.assigns[:user]))
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
      |> put_flash(:error, "Ви не авторизовані для редагування цього
      типу пам'яток")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end
end
