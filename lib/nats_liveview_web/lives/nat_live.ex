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

    <%= for message <- @messages do %>
      <pre><%= inspect message %></pre>
    <% end %>    
    """
  end

  def mount(params, _session, socket) do
    if connected?(socket) do
      Logger.debug("Started with params #{inspect params}")
      # TODO: go get the event stream from the historian and broadcast it back through
      # the channel so the handle_info functions can set up our state.
      
      # TODO: set this subscription up to take the match Id as a parameter from the page params
      :ok = Phoenix.PubSub.subscribe(NatsLiveview.PubSub, "gnat:wasmdome.match_events.#{params["match_id"]}")
    end

    {:ok, assign(socket, messages: [], players: %{})}
  end

  def handle_info(%{event: "gnat_msg", payload: %{body: %{"ActorStarted" => actor_started} = payload}}, socket =  %{assigns: %{messages: messages, players: players}}) do
    Logger.debug("Adding actor")
    players = Map.put(players, actor_started["actor"], Map.delete(actor_started, "actor"))
    {:noreply, assign(socket, messages: [payload | messages], players: players)}

  end
    
  def handle_info(%{event: "gnat_msg", payload: payload}, socket = %{assigns: %{messages: messages, players: players}}) do
    Logger.debug("Regular message")
    {:noreply, assign(socket, messages: [payload | messages], players: players)}    
  end

  #def handle_info(:tick, socket) do
  #  Process.send_after(self(), :tick, 3_000)
  #  :ok = Gnat.pub(Gnat, "pawnee", "Leslie Knope recalled from city council #{System.system_time(:second)}")
  #  {:noreply, socket}
  #end
end
