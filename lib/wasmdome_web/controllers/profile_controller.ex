defmodule WasmdomeWeb.ProfileController do
    use WasmdomeWeb, :controller
    alias Wasmdome.Users
    alias Wasmdome.Users.User

    plug :authenticate # when action in []    
  
    def index(conn, _params) do        
      profile = conn.assigns.current_user |> Wasmdome.Users.get_user_for_oauth    
      
      {:ok, decoded} = Wasmdome.Wascap.decode_jwt(profile.account_jwt)
      
      render conn, "index.html", profile: profile, account: decoded
    end

    def edit(conn, _params) do      
      changeset =
        conn.assigns.current_user
        |> Wasmdome.Users.get_user_for_oauth
        |> Wasmdome.Users.change_user

      render conn, "edit.html", changeset: changeset
    end

    def update(conn, %{"user" => user_params}) do
      {:ok, user} = 
        conn.assigns.current_user
        |> Wasmdome.Users.get_user_for_oauth
        |> Users.update_user(user_params)      
      
      conn
      |> redirect(to: Routes.profile_path(conn, :index))
    end
  end
  