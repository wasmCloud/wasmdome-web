defmodule Core.BoardTest do
    use ExUnit.Case    
    import Core.Board
    
    test "creates a board" do
        assert %Core.Board{height: 10, width: 10, mechs: %{}} = Core.Board.new(10, 10)
    end

    test "Rejects an Update For a Turn in the Future" do
        board1 = spawn_one(30,30)
        evt = %{"TurnEvent" => 
                %{"actor" => "MCPBZXJDXCWRJAOPHXCBGVU55BAKCQSNUXUQRKRLI6RWYRFJW7W64JH4", 
                "match_id" => "45", 
                "turn" => 10, 
                "turn_event" => 
                    %{"PositionUpdated" => 
                        %{"mech" => "MCPBZXJDXCWRJAOPHXCBGVU55BAKCQSNUXUQRKRLI6RWYRFJW7W64JH4",
                        "position" => %{"x" => 15, "y" => 20}}}},
                topic: "wasmdome.match_events.45.replay"}
        board2 = apply_event(board1, evt, 1)
        assert board1 = board2 # no new events have been applied
    end

    test "Updates a Player Position" do

        board = spawn_one(30,30)        

        evt = %{"TurnEvent" => 
                    %{"actor" => "MCPBZXJDXCWRJAOPHXCBGVU55BAKCQSNUXUQRKRLI6RWYRFJW7W64JH4", 
                      "match_id" => "45", 
                      "turn" => 10, 
                      "turn_event" => 
                        %{"PositionUpdated" => 
                            %{"mech" => "MCPBZXJDXCWRJAOPHXCBGVU55BAKCQSNUXUQRKRLI6RWYRFJW7W64JH4",
                              "position" => %{"x" => 15, "y" => 20}}}},
                 topic: "wasmdome.match_events.45.replay"}
        
        board = apply_event(board, evt, 10)

        assert %Core.Board{ mechs: %{"MCPBZXJDXCWRJAOPHXCBGVU55BAKCQSNUXUQRKRLI6RWYRFJW7W64JH4" => 
            %Core.Mech{ pk: "MCPBZXJDXCWRJAOPHXCBGVU55BAKCQSNUXUQRKRLI6RWYRFJW7W64JH4", 
                        position: {15, 20}}}, width: 30} = board        
    end

    test "Takes Damage" do
        board = spawn_one(30,30)

        evt = %{"TurnEvent" => 
                    %{"actor" => "MCPBZXJDXCWRJAOPHXCBGVU55BAKCQSNUXUQRKRLI6RWYRFJW7W64JH4", 
                      "match_id" => "45", 
                      "turn" => 10, 
                      "turn_event" => 
                        %{"DamageTaken" => 
                            %{"damage_target" => "MCPBZXJDXCWRJAOPHXCBGVU55BAKCQSNUXUQRKRLI6RWYRFJW7W64JH4",
                              "damage" => 100
                            }
                        }
                    },
                 topic: "wasmdome.match_events.45.replay"
                }
        board = apply_event(board, evt, 10)
        assert 900 = board.mechs["MCPBZXJDXCWRJAOPHXCBGVU55BAKCQSNUXUQRKRLI6RWYRFJW7W64JH4"].health
    end

    test "Destroys a Mech" do
        board = spawn_one(30,30)

        evt = %{"TurnEvent" => 
                    %{"actor" => "MCPBZXJDXCWRJAOPHXCBGVU55BAKCQSNUXUQRKRLI6RWYRFJW7W64JH4", 
                      "match_id" => "45", 
                      "turn" => 10, 
                      "turn_event" => 
                        %{"MechDestroyed" => 
                            %{"damage_target" => "MCPBZXJDXCWRJAOPHXCBGVU55BAKCQSNUXUQRKRLI6RWYRFJW7W64JH4" }
                        }
                    },
                 topic: "wasmdome.match_events.45.replay"
                }
        board = apply_event(board, evt, 10)
        assert 0 = board.mechs["MCPBZXJDXCWRJAOPHXCBGVU55BAKCQSNUXUQRKRLI6RWYRFJW7W64JH4"].health
    end

    test "Converts to Grid Piece" do
        board = spawn_one(24, 24)
        mech = Core.Mech.new("MCPBZXJDXCWRJAOPHXCBGVU55BAKCQSNUXUQRKRLI6RWYRFJW7W64JH4",
                        name: "test",
                        avatar: "special",
                        position: {0,0})                        
        piece = Core.Mech.to_gridpiece(mech, board)

        # Origin of the domain model board is bottom left (0,0)
        # A piece at the CSS grid "origin" must be (1, 24)
        # FYI WHY IS CSS GRID 1-BASED INDEXING!?!? WHY WHY WHY
        assert 1 = piece.column
        assert 24 = piece.row
        assert "special" = piece.avatar

        mech = Core.Mech.new("MCPBZXJDXCWRJAOPHXCBGVU55BAKCQSNUXUQRKRLI6RWYRFJW7W64JH4",
                        name: "test",
                        avatar: "special",
                        position: {23,23})                        
        piece = Core.Mech.to_gridpiece(mech, board) 
        # (23,23) in the domain is the top right corner
        # must be (24, 1) in CSS grid
        assert 24 = piece.column
        assert 1 = piece.row 
    end

    test "Retrieves a Game Piece by Position" do
        board = spawn_one(30,30)        
        assert :empty = Core.Board.piece_at(board, { 10, 20 })
        assert %Core.Gridpiece{column: 6, row: 25, 
                               avatar: "turret-1", 
                               name: "testo", 
                               original_position: {5,5}} = Core.Board.piece_at(board, { 5,5 })
    end

    test "Prepares a Ready-to-Render List of Board Pieces" do
        board = spawn_one(6,6)
        assert [:empty, :empty, :empty, :empty, :empty, :empty, 
                :empty, :empty, :empty, :empty, :empty, :empty, 
                :empty, :empty, :empty, :empty, :empty, :empty, 
                :empty, :empty, :empty, :empty, :empty, :empty, 
                :empty, :empty, :empty, :empty, :empty, :empty, 
                :empty, :empty, :empty, :empty, :empty, 
                    %Core.Gridpiece{avatar: "turret-1", column: 6, row: 1}] = 
                Core.Board.render_pieces(board)  # (6,1) in the CSS grid is (0,0) on a 6x6 board
    end



    defp spawn_one(h, w) do
        board = new(h, w)
        apply_event(board, 
                %{"TurnEvent" => 
                            %{"actor" => "MCPBZXJDXCWRJAOPHXCBGVU55BAKCQSNUXUQRKRLI6RWYRFJW7W64JH4", 
                            "match_id" => "45", 
                            "turn" => 1, 
                            "turn_event" => 
                                %{"MechSpawned" => 
                                    %{"mech" => "MCPBZXJDXCWRJAOPHXCBGVU55BAKCQSNUXUQRKRLI6RWYRFJW7W64JH4",
                                    "position" => %{"x" => 5, "y" => 5},
                                    "team" => "earth",
                                    "avatar" => "turret-1",
                                    "name" => "testo",
                                    "health" => 1000                              
                                    }}},
                            topic: "wasmdome.match_events.45.replay"}, 1)
            
    end
end