defmodule WasmdomeWeb.ProfileController do
    use WasmdomeWeb, :controller

    plug :authenticate # when action in []    
  
    def index(conn, _params) do
      user =  get_session(conn, :current_user)
      profile = Wasmdome.Users.get_user_by_oauth(user.id)   
      {:ok, decoded } = Wasmdome.Wascap.decode_jwt(profile.account_jwt)         
      render conn, "index.html", current_user: user, profile: profile, account: decoded
    end
  end
  