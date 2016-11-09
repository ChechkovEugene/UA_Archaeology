defmodule UaArchaeology.SessionController do
  use UaArchaeology.Web, :controller

  def new(conn, _params) do
    render conn, "new.html"
  end
end
