defmodule WasmdomeWeb.LeaderboardController do
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

    alias Wasmdome.Leaderboards
  
    def index(conn, _params) do
      entries = Leaderboards.list_entries()
      render conn, "index.html", current_user: get_session(conn, :current_user),
                                 entries: entries
    end
  end
  