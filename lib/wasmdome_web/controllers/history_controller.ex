defmodule WasmdomeWeb.HistoryController do
    use WasmdomeWeb, :controller        

    alias Wasmdome.History
  
    def index(conn, _params) do
      history = History.match_history()
      render conn, "index.html", history: history
    end
  end
  