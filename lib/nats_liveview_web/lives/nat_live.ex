defmodule NatsLiveviewWeb.NatLive do
  use Phoenix.LiveView
  require Logger


  # You could use "prepend" in this type of feed, although each message needs to have
  # some unique ID (could be the received time?) and I didn't want to set that up.
  def render(assigns) do
    ~L"""
    <%= for {_pk, player} <- @players do %>
      <%= player["name"]%> (<%= player["avatar"]%>) - <%= player["team"]%>      
      <br/>
    <% end %>

    <br/>
    <%= if @board != %{} do %>
    <div class="game-board" 
      style="display: grid; grid-template-columns: <%= for _x <- 0..@board.width-1 do %> 32px <% end %>; grid-template-rows: <%= for _y <- 0..@board.height-1 do %> 32px <% end %>">
    <%= for piece <- @pieces do %>
     <%= if piece != :empty do %>
        <div style="grid-column: <%= piece.column%>; grid-row: <%= piece.row%>">
          <%= piece.avatar %>
        </div>      
     <% end %>
    <% end %>
    </div>
    <% end %>

    <br/>
    <pre><%= inspect @pieces %></pre>

    <%= for evt <- @events do %>
      <pre><%= inspect evt %></pre>
    <% end %>    
    """
  end

  def mount(params, _session, socket) do
    if connected?(socket) do
      Logger.debug("Started with params #{inspect params}")
      # TODO: go get the event stream from the historian and broadcast it back through
      # the channel so the handle_info functions can set up our state.
      
      # TODO: set this subscription up to take the match Id as a parameter from the page params
      :ok = Phoenix.PubSub.subscribe(NatsLiveview.PubSub, "gnat:wasmdome.match_events.#{params["match_id"]}.replay")
    end

    {:ok, assign(socket, events: [], players: %{}, tindex: 1000, match_id: params["match_id"], board: %{}, pieces: [])}
  end

  def handle_info(%{event: "gnat_msg", payload: 
        %{body: 
            %{"MatchCreated" => 
              %{"board_height" => h, "board_width" => w}
            }
        }},
        socket = %{assigns: %{}}) do
    Logger.debug("Match created")          
    board = Core.Board.new(w, h)
    {:noreply, assign(socket, board: board )}
  end

  def handle_info(%{event: "gnat_msg", payload: %{body: %{"ActorStarted" => actor_started} = payload}}, 
        socket =  %{assigns: %{events: events, players: players}}) do
    Logger.debug("Adding actor")
    players = Map.put(players, actor_started["actor"], Map.delete(actor_started, "actor"))
    {:noreply, assign(socket, events: [payload | events], players: players)}

  end
    
  def handle_info(%{event: "gnat_msg", payload: payload}, 
        socket = %{assigns: %{events: events, board: board, tindex: tindex}}) do
    Logger.debug("Regular message: #{inspect payload.body}")
    board = Core.Board.apply_event(board, payload.body, tindex)
    pieces = Core.Board.render_pieces(board)
    {:noreply, assign(socket, events: [payload | events], board: board, pieces: pieces)}    
  end

  #def handle_info(:tick, socket) do
  #  Process.send_after(self(), :tick, 3_000)
  #  :ok = Gnat.pub(Gnat, "pawnee", "Leslie Knope recalled from city council #{System.system_time(:second)}")
  #  {:noreply, socket}
  #end
end
