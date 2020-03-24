defmodule WasmdomeWeb.PageController do
  use WasmdomeWeb, :controller

  plug :allow_anonymous 

  def index(conn, _params) do
    render conn, "index.html"
  end
end
