defmodule WasmdomeWeb.ScheduleController do
    use WasmdomeWeb, :controller  
    
    alias Wasmdome.Users
    alias Wasmdome.ScheduledMatches
    alias Wasmdome.ScheduledMatches.Match
    
    def index(conn, _params) do      
      render conn, "index.html", matches: ScheduledMatches.list_schedule()
    end

    def compete(conn, _params) do
      profile = conn.assigns.current_user |> Users.get_user_for_oauth
      decoded = profile |> decode
      token = ScheduledMatches.generate_token(decoded.subject)
      if token do
        conn |> put_flash(:info, "Good luck, Champion! To get your arena credentials, run: wasmdome compete #{decoded.subject} #{token}")
      else
        conn |> put_flash(:error, "Sorry, we could not generate an access token for arena credentials")
      end
      |> redirect(to: Routes.schedule_path(conn, :index))            
    end

    defp decode(profile) do
      if profile && String.length(profile.account_jwt) > 1 do
        case Wasmdome.Wascc.decode_jwt(profile.account_jwt) do
          {:ok, decoded} -> decoded
          {:error, _e} -> nil
        end
      else 
        nil
      end 
    end

end

