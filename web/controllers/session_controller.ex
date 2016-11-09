defmodule UaArchaeology.SessionController do
  use UaArchaeology.Web, :controller

  alias UaArchaeology.User

  def new(conn, _params) do
    render conn, "new.html", changeset: User.changeset(%User{})
  end
end
