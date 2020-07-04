defmodule WasmdomeWeb.ProfileController do
    use WasmdomeWeb, :controller
    alias Wasmdome.Users
    alias Wasmdome.Users.User    
  
    def index(conn, _params) do        
      profile = conn.assigns.current_user |> Users.get_user_for_oauth   
      IO.inspect profile       
      decoded = if profile && String.length(profile.account_jwt) > 1 do
        case Wasmdome.Wascc.decode_jwt(profile.account_jwt) do
          {:ok, decoded} -> decoded
          {:error, _e} -> %{name: "Error", issuer: "Error decoding JWT", subject: "Error decoding JWT"}
        end
      else 
        %{name: "None", issuer: "No Account JWT Set", subject: "No Account JWT Set"}
      end 
      
      render conn, "index.html", profile: profile, account: decoded
    end

    def edit(conn, _params) do      
      changeset =
        conn.assigns.current_user
        |> Users.get_user_for_oauth
        |> Users.change_user

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
  