defmodule UaArchaeology.PageController do
  use UaArchaeology.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
