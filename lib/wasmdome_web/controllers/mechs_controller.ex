defmodule WasmdomeWeb.MechsController do
    use WasmdomeWeb, :controller
    
    alias Wasmdome.Mechs
  
    def index(conn, _params) do      
      mechs = Mechs.my_mechs(conn.assigns.current_user.id)        
      render conn, "index.html", mechs: mechs
    end

  end
  