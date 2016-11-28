defmodule UaArchaeology.ResearchLevelController do
  use UaArchaeology.Web, :controller

  alias UaArchaeology.ResearchLevel

  plug :scrub_params, "research_level" when action in [:create, :update]
  plug :assign_user
  plug :authorize_user when action in [:new, :create, :update, :edit, :delete]

  def index(conn, _params) do
    research_levels = Repo.all(ResearchLevel)
    # research_levels = Repo.all(assoc(conn.assigns[:user], :research_levels))
    render(conn, "index.html", site_types: research_levels)
  end

  def new(conn, _params) do
    changeset =
      conn.assigns[:user]
      |> build_assoc(:site_types)
      |> ResearchLevel.changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"research_level" => research_level_params}) do
    changeset =
      conn.assigns[:user]
      |> build_assoc(:research_levels)
      |> ResearchLevel.changeset(research_level_params)

    case Repo.insert(changeset) do
      {:ok, _research_level} ->
        conn
        |> put_flash(:info, "Research level created successfully.")
        |> redirect(to: user_research_level_path(conn, :index, conn.assigns[:user]))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    research_level = Repo.get!(ResearchLevel, id)
    # research_level = Repo.get!(assoc(conn.assigns[:user], :research_levels), id)
    render(conn, "show.html", site_type: research_level)
  end

  def edit(conn, %{"id" => id}) do
    research_level = Repo.get!(assoc(conn.assigns[:user], :research_levels), id)
    changeset = ResearchLevel.changeset(research_level)
    render(conn, "edit.html", research_level: research_level, changeset: changeset)
  end

  def update(conn, %{"id" => id, "research_level" => research_level_params}) do
    research_level = Repo.get!(assoc(conn.assigns[:user], :research_levels), id)
    changeset = ResearchLevel.changeset(research_level, research_level_params)

    case Repo.update(changeset) do
      {:ok, research_level} ->
        conn
        |> put_flash(:info, "Research level updated successfully.")
        |> redirect(to: user_research_level_path(conn, :show, conn.assigns[:user],
          research_level))
      {:error, changeset} ->
        render(conn, "edit.html", research_level: research_level, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    research_level = Repo.get!(assoc(conn.assigns[:user], :research_levels), id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(research_level)

    conn
    |> put_flash(:info, "Research level deleted successfully.")
    |> redirect(to: user_research_level_path(conn, :index, conn.assigns[:user]))
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
        рівня археологічних досліджень!")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end
end
