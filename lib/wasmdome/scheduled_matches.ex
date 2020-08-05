defmodule Wasmdome.ScheduledMatches do
    @moduledoc """
    The schedule context
    """

    alias Wasmdome.ScheduledMatches.Match
    alias Timex.Duration

    def list_schedule do
        sched = scheduled_matches()   
        case sched do
            [ h | t] -> [ put_in(h.current_mechs, length(mechs_in_lobby())) | t ]
            [] -> []
            nil -> []
        end
    end    

    def next_match([]) do 
        nil
    end
    def next_match(nil) do
        nil
    end
    def next_match(schedule) do        
        schedule
        |> Enum.find( fn m -> m.starts_in_mins >= 0 end)        
    end

    def generate_token(account) do
        tok_req = "{\"account_key\": \"#{account}\"}"
        case Gnat.request(Gnat, "wasmdome.internal.ott.gen", tok_req, receive_timeout: 2500) do
            {:ok, %{body: rawbody}} -> rawbody
            {:error, _} -> nil
        end
    end

    def mechs_in_lobby do
        case Gnat.request(Gnat, "wasmdome.internal.arena.control", "\"QueryMechs\"", receive_timeout: 3500) do
            {:ok, %{body: rawbody}} -> Jason.decode!(rawbody) |> extract_mechs
            {:error, _} -> []
        end
    end

    def scheduled_matches do
        case Gnat.request(Gnat, "wasmdome.public.arena.schedule", "", receive_timeout: 2500) do
            {:ok, %{body: rawbody}} -> Jason.decode!(rawbody) |> extract_schedule
            {:error, _} -> []
        end
    end

    defp extract_mechs(%{"mechs" => m}) do
        m
    end

    defp extract_schedule(matches) do        
        matches 
        |> Enum.map(fn m -> convert(m) end)
    end

    defp convert(%{
        "aps_per_turn" => aps_per_turn,
        "entry" => %{
          "board_height" => height,
          "board_width" => width,
          "match_start" => start_s,
          "max_actors" => max_actors,
          "max_turns" => max_turns
        },
        "match_id" => match_id
      }) do
        now = DateTime.utc_now
        then = Timex.Parse.DateTime.Parser.parse!(start_s, "{ISO:Extended:Z}")
        diff = DateTime.diff(then, now) |> Timex.Duration.from_seconds
        friendly = diff |> Timex.Format.Duration.Formatters.Humanized.format
        mins = Duration.to_minutes(diff, truncate: true)
        %Match{
            aps_per_turn: aps_per_turn,
            board_height: height,
            board_width: width,
            max_mechs: max_actors,
            max_turns: max_turns,
            starts_in_friendly: pretty(mins, friendly),
            starts_in_mins: mins,
            current_mechs: 0,
            id: match_id
        }
    end    

    defp pretty(mins, friendly) do
        if mins < 0 do
            "#{friendly} ago"
        else
            "in #{friendly}"
        end
    end
end 