defmodule WasmdomeWeb.DashboardLive do
    require Logger
    use Phoenix.LiveView

    def mount(params, _session, socket) do
        if connected?(socket) do
          Logger.debug("Started with params #{inspect params}")
        end

        {:ok, assign(socket, testing: "hello")}
    end

end
