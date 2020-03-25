defmodule WasmdomeWeb.ReplayController do
    use WasmdomeWeb, :controller
    alias Core.Board

    plug :authenticate 
  
    def index(conn, params) do        
    
      board = Board.new(24, 24)
      # put at corners
      board = spawn(board, "test", "turret-1", "earth", "Turret", 1000,23, 23)
      board = spawn(board, "testturret", "turret-1", "earth", "Turret 2",1000, 0, 0)

      board = spawn(board, "test2", "bot-1", "earth", "bot1", 1000,1, 1)
      board = spawn(board, "test3", "bot-2", "earth", "bot2", 900,2, 2)
      board = spawn(board, "test4", "bot-3", "earth", "bot3", 800,3, 3)
      board = spawn(board, "test5", "bot-4", "earth", "bot4", 700,4, 4)
      board = spawn(board, "test6", "bot-5", "earth", "bot5", 600,5, 5)
      board = spawn(board, "test7", "bot-6", "earth", "bot6", 500,6, 6)
      board = spawn(board, "test8", "bot-7", "earth", "bot7", 400,7, 7)
      board = spawn(board, "test9", "bot-8", "earth", "bot8", 300,8, 8)

      board = spawn(board, "boylur", "boylur", "boylur", "Boylur Plait", 200,9, 9)

      # put at bottom right
      board = spawn(board, "kodefriez", "kodefriez", "boylur", "Kode Friez", 500, 23, 0)
      board = spawn(board, "deployjenkins", "deployjenkins", "boylur", "Deeploy Jennkins", 1000,11, 11)

      # put at top right
      board = spawn(board, "siremony", "siremony", "boylur", "Sir Emony", 800, 0, 23)

      board = spawn(board, "turret2", "turret-2", "boylur", "Turret 2", 100,13, 13)
      board = spawn(board, "turret3", "turret-3", "boylur", "Turret 3", 500,14, 14)
      board = spawn(board, "turret4", "turret-4", "boylur", "Turret 4", 700,15, 15)
      pieces = Board.render_pieces(board)
      
      
      players = board.mechs
                |> Map.values                

      render conn, "index.html", board: board, pieces: pieces, players: players, match_id: params["match_id"], turn: params["turn"]
    end


    defp spawn(board, actor, avatar, team, name, health, x, y) do        
        Board.apply_event(board, 
                %{"TurnEvent" => 
                            %{"actor" => actor, 
                            "match_id" => "45", 
                            "turn" => 1, 
                            "turn_event" => 
                                %{"MechSpawned" => 
                                    %{"mech" => actor,
                                    "position" => %{"x" => x, "y" => y},
                                    "team" => team,
                                    "avatar" => avatar,
                                    "name" => name,
                                    "health" => health                              
                                    }}},
                            topic: "wasmdome.match_events.45.replay"}, 1)
            
    end
  end
  