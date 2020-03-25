defmodule Core.Board do
    require Logger
    defstruct ~w(
        width
        height
        mechs
    )a

    def new(width, height) do
        %__MODULE__{
            width: width,
            height: height,
            mechs: %{}
        }
    end

    # Return the existing board if attempting to apply an event greater than a given turn
    def apply_event(board, %{ "TurnEvent" => %{"turn" => t}}, as_of) when t > as_of do 
        board
    end

    def apply_event(board, %{ "TurnEvent" => 
                                %{"turn_event" => 
                                %{"PositionUpdated" => 
                                    %{"mech" => mech, "position" => %{"x" => x, "y" => y}}}}}, _as_of) do
        
        put_in(board.mechs[mech].position, {x, y})
    end

   def apply_event(board, %{ "TurnEvent" => 
                                %{"turn_event" => 
                                    %{"MechSpawned" => 
                                        %{"mech" => pk,
                                         "position" => %{"x" => x, "y" => y},
                                         "team" => team,
                                         "avatar" => avatar,
                                         "name" => name,
                                         "health" => health}
                                    }
                                }
                            }, _as_of) do        
        new_mech = Core.Mech.new(pk, position: {x,y}, team: team, avatar: avatar, name: name, health: health)
        put_in(board.mechs[pk], new_mech)            
    end

    def apply_event(board, %{ "TurnEvent" => 
                                %{"turn_event" => 
                                    %{"DamageTaken" => 
                                        %{"damage_target" => pk,
                                          "damage" => dmg
                                        }
                                    }
                                }
                            }, _as_of) do        
        put_in(board.mechs[pk], Core.Mech.take_damage(board.mechs[pk], dmg))            
    end


    def apply_event(board,  %{ "TurnEvent" => 
                                %{"turn_event" => 
                                    %{"MechDestroyed" => 
                                        %{ "damage_target" => pk }
                                    }
                                }
                            }, _as_of) do
        put_in(board.mechs[pk], Core.Mech.destroy(board.mechs[pk]))        
    end

    # Catch-all, if we get an event the board doesn't care about
    def apply_event(board, _event, _as_of) do
        board
    end

    def piece_at(board, position) do 
        board.mechs
            |> Map.values()
            |> Enum.find(fn m -> m.position == position end)
            |> Core.Mech.to_gridpiece(board)
    end

    def render_pieces(board) do
        for col <- 0..board.width-1 do
            for row <- 0..board.height-1 do
                piece_at(board, { col, row })
            end
        end
        |> List.flatten
    end

end