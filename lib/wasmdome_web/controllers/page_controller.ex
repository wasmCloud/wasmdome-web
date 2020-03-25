defmodule WasmdomeWeb.PageController do
  use WasmdomeWeb, :controller  

  def index(conn, _params) do
    render conn, "index.html"
  end
end
