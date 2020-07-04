defmodule WasmdomeWeb.ArenaLive do
    require Logger
    use Phoenix.LiveView
    alias Wasmdome.Arena.MechInfo
    alias Wasmdome.Arena
    
    alias WasmdomeWeb.Router.Helpers, as: Routes

    def mount(params, _session, socket) do
        if connected?(socket) do
            Logger.debug("Started with params #{inspect params}")            
            :ok = Phoenix.PubSub.subscribe(Wasmdome.PubSub, "gnat:wasmdome.public.arena.events")            
        end

        #TODO: query the list of mechs 

        {:ok, assign(socket, mechs: Arena.get_arena_lobby())}
    end
        
    def handle_info(%{event: "gnat_msg", payload: 
        %{body:
            %{"MechConnected" => 
                %{"actor" => actor, 
                  "avatar" => avatar,
                  "name" => name,
                  "team" => team,
                  "time" => time}
            }
        }},     
        socket = %{assigns: %{mechs: mechs}}) do

        newmech = %MechInfo{ id: actor, avatar: avatar, team: team, name: name}

        {:noreply, assign(socket, mechs: [newmech | mechs])}
    end

    def handle_info(%{event: "gnat_msg", payload:
        %{body: 
            %{"MechDisconnected" => 
                %{"actor" => actor,
                  "time" => time}            
            }
        }},
        socket = %{assigns: %{mechs: mechs}}) do

        {:noreply, assign(socket, mechs: mechs |> Enum.filter(fn(m) -> m.id != actor end))}
    end    
end

