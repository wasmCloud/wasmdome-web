defmodule WasmdomeWeb.Auth do
    use Phoenix.Controller, namespace: WasmdomeWeb

    import Plug.Conn
    import WasmdomeWeb.Gettext
    import Phoenix.LiveView.Controller

    def authenticate(conn, _params) do
        user = get_session(conn, :current_user)
        case user do
         nil ->
             conn
             |> put_flash(:error, "You must be logged in to access that page")
             |> redirect(to: "/auth/auth0") 
             |> halt
         _ ->
           conn
           |> assign(:current_user, user)
        end
    end    

    def allow_anonymous(conn, _params) do
        user = get_session(conn, :current_user)
        case user do
        nil -> 
            conn |> assign(:current_user, nil)
        _ ->
            conn |> assign(:current_user, user)
        end
    end
end