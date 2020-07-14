defmodule Wasmdome.GnatSubscriber do
  use GenServer
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(_args) do    
    Process.send_after(self(), :tick, 15_000)
    Gnat.sub(Gnat, self(), "wasmdome.match.*.events")    
    Gnat.sub(Gnat, self(), "wasmdome.public.arena.events")
  end

  # Rebroadcast the message into Phoenix's PubSub
  def handle_info({:msg, msg = %{body: body, topic: topic}}, state) do
    Logger.debug("Received gnat message: #{inspect msg}")

    if String.starts_with?(topic, "wasmdome.match.") do
      # coalesce all the match events to a single pubsub because we're only running 1 match concurrently
      :ok = WasmdomeWeb.Endpoint.broadcast("gnat:wasmdome.match.events", "gnat_msg", %{body: Jason.decode!(body), topic: topic})
    else
      :ok = WasmdomeWeb.Endpoint.broadcast("gnat:#{topic}", "gnat_msg", %{body: Jason.decode!(body), topic: topic})
    end

    {:noreply, state}
  end

  def handle_info(:tick, state) do    
    nm = Wasmdome.ScheduledMatches.list_schedule() |> Wasmdome.ScheduledMatches.next_match()
    if nm != nil do    
      if nm.starts_in_mins < 0.5 and nm.starts_in_mins >= 0 do
        Process.send_after(self(), :tick, 180_000)
        start_match(nm)
      else
        Process.send_after(self(), :tick, 15_000)
      end
    end 
    {:noreply, state}
  end

  defp start_match(nm) do
    actors = Wasmdome.ScheduledMatches.mechs_in_lobby
    |> Enum.map(fn m -> "\"#{m["id"]}\"" end)
    |> Enum.join(",")

    smcommand = "{\"StartMatch\":{\"match_id\": \"#{nm.id}\", \"board_height\": #{nm.board_height}, \"board_width\": #{nm.board_width}, \"max_turns\": #{nm.max_turns}, \"aps_per_turn\": #{nm.aps_per_turn}, \"actors\": [#{actors}]} }"
    case Gnat.request(Gnat, "wasmdome.internal.arena.control", smcommand, receive_timeout: 1500) do
      {:ok, _} -> Logger.debug "Published match start event for #{nm.id}"
      {:error, e} -> Logger.error "Failed to publish match start event: #{e}"
    end
  end  
end
