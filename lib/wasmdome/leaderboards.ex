defmodule Wasmdome.Leaderboards do
    @moduledoc """
    The Leaderboards context
    """

    alias Wasmdome.Leaderboards.Entry

    def list_entries do
        leaderboard_contents()
    end

    defp leaderboard_contents() do
        case Gnat.request(Gnat, "wasmdome.internal.arena.leaderboard.get", "", receive_timeout: 1500) do
            {:ok, %{body: rawbody}} -> Jason.decode!(rawbody) |> extract_leaderboard
            {:error, _} -> []
        end
    end

    defp extract_leaderboard(%{"stats" => stats, "mechs" => mech_map}) do
        stats
        |> Enum.map(fn ({k,v}) -> convert(k,v, mech_map) end)
        |> Enum.sort(&(&1.score > &2.score))
    end

    defp convert(key, %{ 
                "score" => score,
                "kills" => kills,
                "draws" => draws,
                "wins" => wins,
                "deaths" => deaths
                }, mech_map) do
        %Entry{
                name: mech_map[key]["name"],
                avatar: mech_map[key]["avatar"],
                team: mech_map[key]["team"],
                points: score,
                id: key,
                kills: kills,
                deaths: deaths,
                draws: draws,
                wins: wins
        }
    end
end 