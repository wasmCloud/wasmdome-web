defmodule Wasmdome.Leaderboards do
    @moduledoc """
    The Leaderboards context
    """

    alias Wasmdome.Leaderboards.Entry

    def list_entries do
        [
            %Entry{name: "Kevin", avatar: "bot-5", wins: 30, losses: 21, draws: 5, 
                    last_activity: "Won a match, 3 days ago"},
            %Entry{name: "Brooks", avatar: "bot-3", wins: 0, losses: 112, draws: 5,
                    last_activity: "Lost, 3 days ago"}
        ]
    end
end 