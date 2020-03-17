defmodule WasmdomeWeb.DashboardController do
    use WasmdomeWeb, :controller

    plug :secure
    
    defp secure(conn, _params) do
      user = get_session(conn, :current_user)
      case user do
       nil ->
           conn |> redirect(to: "/auth/auth0") |> halt
       _ ->
         conn
         |> assign(:current_user, user)
      end
    end

    alias Wasmdome.Dashboard
  
    def index(conn, _params) do
      history = Dashboard.match_history()
      render conn, "index.html", current_user: get_session(conn, :current_user),
                                 history: history
    end
  end
  