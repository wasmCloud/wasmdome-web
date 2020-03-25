defmodule WasmdomeWeb.LeaderboardController do
    use WasmdomeWeb, :controller    

    alias Wasmdome.Leaderboards
  
    def index(conn, _params) do
      entries = Leaderboards.list_entries()
      render conn, "index.html", entries: entries
    end
  end
  