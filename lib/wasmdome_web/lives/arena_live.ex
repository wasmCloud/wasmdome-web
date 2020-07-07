defmodule WasmdomeWeb.ArenaLive do
    require Logger
    use Phoenix.LiveView
    alias Wasmdome.Arena.MechInfo
    alias Wasmdome.Arena
    alias Wasmdome.ScheduledMatches
    alias Wasmdome.ScheduledMatches.Match
    alias Core.Board
    
    alias WasmdomeWeb.Router.Helpers, as: Routes

    def mount(params, _session, socket) do
        if connected?(socket) do
            Logger.debug("Started with params #{inspect params}")            
            :ok = Phoenix.PubSub.subscribe(Wasmdome.PubSub, "gnat:wasmdome.public.arena.events")    
            :ok = Phoenix.PubSub.subscribe(Wasmdome.PubSub, "gnat:wasmdome.match.events")
        end        
        Process.send_after(self(), :tick, 5_000)
        {:ok, assign(socket, mechs: Arena.get_arena_lobby(), 
                        # Odd, but it's possible for us to get the spawn message before we get MatchStarted, so we need a placeholder board
                             board: Board.new(24,24), 
                     running_match: nil,
                           results: nil,
                        next_match: ScheduledMatches.list_schedule() |> ScheduledMatches.next_match()) }
    end

    def handle_info(:tick, socket = %{assigns: %{mechs: m, next_match: _nm, running_match: rm, board: b}}) do
        nm = if !rm do
            Process.send_after(self(), :tick, 5_000)
            ScheduledMatches.list_schedule() |> ScheduledMatches.next_match()            
        else
            nil
        end
        
        {:noreply, assign(socket, mechs: m, next_match: nm, running_match: rm, board: b )}
    end

    def handle_info(%{event: "gnat_msg", payload:
        %{body:
            %{"MatchStarted" =>
                %{
                    "match_id" => match_id,
                    "actors" => actors,
                    "board_height" => height,
                    "board_width" => width,
                    "start_time" => start_time
                }                
            }
        }},
        socket = %{assigns: %{mechs: mechs, next_match: nm, running_match: rm, board: b}}) do
        
        Logger.debug "Match #{match_id} started"
        board = %Board{ b | height: height, width: width }
        new_rm = if rm do
           %Match{ rm | board_height: height, board_width: width } 
        else
            %Match{
                board_height: height,
                board_width: width,
                turn: 0
            }
        end        
        {:noreply, assign(socket, mechs: mechs, next_match: nil, running_match: new_rm, board: board)}
    end

    def handle_info(%{event: "gnat_msg", payload:
        %{body:
            %{"MatchCompleted" =>
                %{
                    "match_id" => match_id,
                    "time" => time,
                    "cause" => endcause
                }
            }
        }},
        socket = %{assigns: %{mechs: mechs, next_match: _nm, running_match: _rm, board: b}}) do

        Logger.debug "Match #{match_id} completed"
                 
        results = case endcause do
            %{"MaxTurnsCompleted" => %{"survivors" => survivors}} -> {:survivors, Enum.filter(mechs, fn m -> m.id in survivors end) }
            %{ "MechVictory" => victor } -> {:victory, victor }
        end        
        Process.send_after(self(), :tick, 120_000)  # Start the schedule poller again
        
        {:noreply, assign(socket, mechs: mechs, next_match: nil, running_match: nil, board: Board.new(24,24), results: results)}
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
        socket = %{assigns: %{mechs: mechs, next_match: nm, running_match: rm, board: b}}) do

        newmech = %MechInfo{ id: actor, avatar: avatar, team: team, name: name}
        

        {:noreply, assign(socket, mechs: [newmech | mechs], next_match: nm, running_match: rm, board: b)}
    end

    def handle_info(%{event: "gnat_msg", payload:
        %{body: 
            %{"MechDisconnected" => 
                %{"actor" => actor,
                  "time" => time}            
            }
        }},
        socket = %{assigns: %{mechs: mechs, next_match: nm, board: b, running_match: rm}}) do

        {:noreply, assign(socket, mechs: mechs |> Enum.filter(fn(m) -> m.id != actor end), next_match: nm, board: b, running_match: rm)}
    end    

    def handle_info(%{event: "gnat_msg", payload:
        %{body:  turnevent = %{"TurnEvent" => 
            %{"actor" => _actor,
             "match_id" => match_id,
             "turn" => turn,
             "turn_event" => _te}
            }
        }},
        socket = %{assigns: %{mechs: mechs, next_match: nm, running_match: rm, board: b}}) do

        b = b |> Board.apply_event(turnevent, 10_000)        
        new_rm = if rm do
            %Match{ rm | turn: turn }
        else
            %Match{ id: match_id, turn: turn }
        end
        {:noreply, assign(socket, mechs: mechs, next_match: nil, running_match: new_rm, board: b)}
    end

    def handle_event("close_results", _value, socket) do
        {:noreply, assign(socket, results: nil)}
    end
end

