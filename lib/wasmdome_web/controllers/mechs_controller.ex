defmodule WasmdomeWeb.MechsController do
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

    alias Wasmdome.Mechs
  
    def index(conn, _params) do
      user =  get_session(conn, :current_user)
      mechs = Mechs.my_mechs(user.id)        
      render conn, "index.html", current_user: user, mechs: mechs
    end
  end
  