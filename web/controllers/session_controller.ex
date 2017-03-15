defmodule UaArchaeology.SessionController do
  use UaArchaeology.Web, :controller

  alias UaArchaeology.User

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  plug :scrub_params, "user" when action in [:create]

  def new(conn, _params) do
    render conn, "new.html", changeset: User.changeset(%User{})
  end

  def create(conn, %{"user" => %{"username" => username,
  "password" => password}})
  when not is_nil(username) and not is_nil(password) do
    user = Repo.get_by(User, username: username)
    sign_in(user, password, conn)
  end

  def create(conn, _) do
    IO.puts "Create2"
    failed_login(conn)
  end

  defp failed_login(conn) do
    dummy_checkpw()
    conn
    |> put_session(:current_user, nil)
    |> put_flash(:error, "Невірна комбінація логін/пароль!")
    |> redirect(to: page_path(conn, :index))
    |> halt()
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:current_user)
    |> put_flash(:info, "Вихід був успішний!")
    |> redirect(to: page_path(conn, :index))
  end

  defp sign_in(user, password, conn) when is_nil(user) do
    failed_login(conn)
  end

  defp sign_in(user, password, conn) do
    if checkpw(password, user.password_digest) do
      conn
      |> put_session(:current_user, %{id: user.id, username: user.username,
        role_id: user.role_id})
      |> put_flash(:info, "Логін успішний!")
      |> redirect(to: page_path(conn, :index))
    else
      failed_login(conn)
    end
  end
end
