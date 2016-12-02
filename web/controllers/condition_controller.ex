defmodule UaArchaeology.ConditionController do
  use UaArchaeology.Web, :controller

  alias UaArchaeology.Condition

  plug :scrub_params, "condition" when action in [:create, :update]
  plug :assign_user
  plug :authorize_user when action in [:new, :create, :update, :edit, :delete]

  def index(conn, _params) do
    conditions = Repo.all(Condition)
    # conditions = Repo.all(assoc(conn.assigns[:user], :conditions))
    render(conn, "index.html", conditions: conditions)
  end

  def new(conn, _params) do
    changeset =
      conn.assigns[:user]
      |> build_assoc(:conditions)
      |> Condition.changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"condition" => condition_params}) do
    changeset =
      conn.assigns[:user]
      |> build_assoc(:conditions)
      |> Condition.changeset(condition_params)

    case Repo.insert(changeset) do
      {:ok, _condition} ->
        conn
        |> put_flash(:info, "Condition created successfully.")
        |> redirect(to: user_condition_path(conn, :index, conn.assigns[:user]))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    condition = Repo.get!(Condition, id)
    # condition = Repo.get!(assoc(conn.assigns[:user], :conditions), id)
    render(conn, "show.html", condition: condition)
  end

  def edit(conn, %{"id" => id}) do
    condition = Repo.get!(assoc(conn.assigns[:user], :conditions), id)
    changeset = Condition.changeset(condition)
    render(conn, "edit.html", condition: condition, changeset: changeset)
  end

  def update(conn, %{"id" => id, "condition" => condition_params}) do
      condition = Repo.get!(assoc(conn.assigns[:user], :conditions), id)
      changeset = Condition.changeset(condition, condition_params)

      case Repo.update(changeset) do
        {:ok, condition} ->
          conn
          |> put_flash(:info, "Condition updated successfully.")
          |> redirect(to: user_condition_path(conn, :show, conn.assigns[:user],
            condition))
        {:error, changeset} ->
          render(conn, "edit.html", condition: condition, changeset: changeset)
      end
  end

  def delete(conn, %{"id" => id}) do
      condition = Repo.get!(assoc(conn.assigns[:user], :conditions), id)

      # Here we use delete! (with a bang) because we expect
      # it to always work (and if it does not, it will raise).
      Repo.delete!(condition)

      conn
      |> put_flash(:info, "Стан успішно видалено.")
      |> redirect(to: user_condition_path(conn, :index, conn.assigns[:user]))
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
      |> put_flash(:error, "Ви не авторизовані для редагування цього стану!")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end
end
