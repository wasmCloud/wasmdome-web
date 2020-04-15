defmodule WasmdomeWeb.DashboardLive do
    require Logger
    use Phoenix.LiveView

    alias Wasmdome.Hosts.ActorInfo
    alias Wasmdome.Hosts.HostInfo
    alias WasmdomeWeb.Router.Helpers, as: Routes

    def mount(params, _session, socket) do
        if connected?(socket) do
          Logger.debug("Started with params #{inspect params}")
          Process.send_after(self(), :tick, 3_000)
        end

        {:ok, assign(socket, hosts: [])}
    end

    def handle_info(:tick, socket = %{assigns: %{hosts: hosts}}) do
      host_id = generate_name()
      

      if Enum.count(hosts) < 6 do
        Process.send_after(self(), :tick, 4_000)
      end 
      
      actor = "M" <> Wasmdome.StringGenerator.string_of_length(55)
      Process.send_after(self(), {:actor_scheduled, {actor, host_id}}, 6_000)
      
      host = %HostInfo{
        host_id: host_id,
        status: :ok,
        actors: []
      }

      {:noreply, assign(socket, hosts: [ host | hosts])}
    end

    def handle_info({:actor_scheduled, {actor, host_id}}, socket = %{assigns: %{hosts: hosts}}) do
      Logger.debug "Actor #{actor} scheduled on #{host_id}"

      hidx = host_index(hosts, host_id)
      newactor = %ActorInfo{
        name: actor,
        status: :loading
      }

      hosts = 
        List.replace_at(hosts, hidx,  
            put_in(Enum.at(hosts, hidx).actors, [ newactor | Enum.at(hosts, hidx).actors ])
        )
        

      if Enum.count(Enum.at(hosts, hidx).actors) < 5 do
        Process.send_after(self(), {:actor_scheduled, {"M" <> Wasmdome.StringGenerator.string_of_length(55), host_id }}, 4_000)
      end

      Process.send_after(self(), {:actor_started, actor, host_id}, 15_000)

      {:noreply, assign(socket, hosts: hosts)}
    end

    def handle_info({:actor_started, actor, host_id}, socket = %{assigns: %{hosts: hosts}}) do
      hidx = host_index(hosts, host_id)
      aidx = actor_index(Enum.at(hosts, hidx).actors, actor)

      actor = %ActorInfo{
        name: actor,
        status: :running
      }

      hosts = List.replace_at(hosts, hidx,
        put_in(Enum.at(hosts, hidx).actors, 
          List.replace_at(Enum.at(hosts, hidx).actors, aidx, actor)
        )
      )

      {:noreply, assign(socket, hosts: hosts)}
    end

    def host_index(hosts, host_id) do
      Enum.with_index(hosts)
      |> Enum.find( fn {h, idx} -> h.host_id == host_id end )
      |> elem(1)
    end

    def actor_index(actors, actor) do
      Enum.with_index(actors)
      |> Enum.find( fn {a, idx} -> a.name == actor end )
      |> elem(1)
    end

    def host_bg(host) do
      if Enum.count(host.actors) > 4 do 
        "bg-gradient-warning"
      else
        "bg-gradient-success"
      end
    end

    def running_count(host) do
      host.actors
      |> Enum.filter(fn actor -> actor.status == :running end)
      |> Enum.count
    end


def generate_name do
    # [[64][64]]
    [["autumn", "hidden", "bitter", "misty", "silent", "empty", "dry", "dark",
    "summer", "icy", "delicate", "quiet", "white", "cool", "spring", "winter",
    "patient", "twilight", "dawn", "crimson", "wispy", "weathered", "blue",
    "billowing", "broken", "cold", "damp", "falling", "frosty", "green",
    "long", "late", "lingering", "bold", "little", "morning", "muddy", "old",
    "red", "rough", "still", "small", "sparkling", "throbbing", "shy",
    "wandering", "withered", "wild", "black", "young", "holy", "solitary",
    "fragrant", "aged", "snowy", "proud", "floral", "restless", "divine",
    "polished", "ancient", "purple", "lively", "nameless"],
    ["waterfall", "river", "breeze", "moon", "rain", "wind", "sea", "morning",
    "snow", "lake", "sunset", "pine", "shadow", "leaf", "dawn", "glitter",
    "forest", "hill", "cloud", "meadow", "sun", "glade", "bird", "brook",
    "butterfly", "bush", "dew", "dust", "field", "fire", "flower", "firefly",
    "feather", "grass", "haze", "mountain", "night", "pond", "darkness",
    "snowflake", "silence", "sound", "sky", "shape", "surf", "thunder",
    "violet", "water", "wildflower", "wave", "water", "resonance", "sun",
    "wood", "dream", "cherry", "tree", "fog", "frost", "voice", "paper",
    "frog", "smoke", "star"]]
    |> Enum.map(fn(names) -> Enum.random(names) end)
    |> Enum.join("-")
  end

end
