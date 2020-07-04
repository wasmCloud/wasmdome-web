defmodule Wasmdome.Arena do
    @moduledoc """
    The arena context
    """

    alias Wasmdome.Arena.MechInfo
    
    def get_arena_lobby() do
        case Gnat.request(Gnat, "wasmdome.internal.arena.control", "\"QueryMechs\"", receive_timeout: 500) do
            {:ok, %{body: rawbody}} -> rawbody |> decode
            {:error, _} -> []
        end
    end

    defp decode(body) do
        Jason.decode!(body) |> extract_mechs
    end

    defp extract_mechs(%{"mechs" => m}) do
        m 
        |> Enum.map(fn m -> convert(m) end) 
    end

    defp convert(%{
        "name" => name,
        "id" => id,
        "team" => team,
        "avatar" => avatar
    }) do
        %MechInfo{ name: name, id: id, team: team, avatar: avatar}
    end
end