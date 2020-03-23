defmodule WasmdomeWeb.ProfileController do
    use WasmdomeWeb, :controller

    plug :authenticate # when action in []    
  
    def index(conn, _params) do
      user =  get_session(conn, :current_user)
      profile = Wasmdome.Users.get_user_by_oauth(user.id)      
      IO.inspect profile
      render conn, "index.html", current_user: user, profile: profile
    end
  end
  