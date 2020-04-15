defmodule WasmdomeWeb.MechsController do
    use WasmdomeWeb, :controller
    
    alias Wasmdome.Mechs
    alias Wasmdome.Mechs.Actorcheck
  
    def index(conn, _params) do      
      mechs = Mechs.my_mechs(conn.assigns.current_user.id)        
      render conn, "index.html", mechs: mechs
    end

    def new(conn, _params) do
      render conn, "new.html"
    end

    def create(conn, %{"actor_module" => %Plug.Upload{path: path}}) do
      case File.read(path) 
      |> extract_jwt 
      |> decode_jwt 
      |> validate_jwt 
      |> enforce_validation
      |> upload_bytes do
        {:ok,check} -> conn 
        |> put_flash(:info, "Uploaded mech #{check.claims.name} (#{check.claims.subject})")         
        {:error, reason} -> conn 
        |> put_flash(:info, "Failed to upload mech:  #{reason}")         
      end |> redirect(to: "/my/mechs")
    end

    defp extract_jwt({:ok, bytes}) do
      case Wasmdome.Wascap.extract_jwt(bytes) do
        {:ok, jwt} -> {:ok, %Actorcheck{jwt: jwt, bytes: bytes}}
        {:error, reason} -> {:error, reason}
      end    
    end

    defp decode_jwt({:ok, %Actorcheck{} = check}) do
      case Wasmdome.Wascap.decode_jwt(check.jwt) do
        {:ok, claims} -> {:ok, %Actorcheck{check | claims: claims }}
        {:error, reason} -> {:error, reason}
      end
    end
    defp decode_jwt(fail) do
      fail
    end

    defp validate_jwt({:ok, %Actorcheck{} = check}) do      
      case Wasmdome.Wascap.validate_jwt(check.jwt) do
        {:ok, validation} -> {:ok, %Actorcheck{check | validation_result: validation }}
        {:error, reason} -> {:error, reason}
      end
    end
    defp validate_jwt(fail) do
      fail
    end

    defp enforce_validation({:ok, %Actorcheck{} = check}) do
      cond do
        check.validation_result.expired -> 
          {:error, "Token is expired"}
        check.validation_result.cannot_use_yet ->
          {:error, "Token cannot yet be used"}
        !check.validation_result.signature_valid ->
          {:error, "Token signature is invalid"}
        true ->
          {:ok, check}
      end
    end
    defp enforce_validation(fail) do
      fail
    end

    defp upload_bytes({:ok, %Actorcheck{} = check}) do
      IO.inspect check
      {:ok, check}
    end
    defp upload_bytes(fail) do
      fail
    end

  end
  