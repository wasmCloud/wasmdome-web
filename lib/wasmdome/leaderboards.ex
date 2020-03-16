defmodule Wasmdome.Leaderboards do
    @moduledoc """
    The Leaderboards context
    """

    alias Wasmdome.Leaderboards.Entry

    def list_entries do
        [
            %Entry{name: "Kevin", avatar: "bot-5", wins: 10, losses: 21, draws: 5, 
                    last_activity: "Won a match, 3 days ago", points: 1},
            %Entry{name: "Brooks", avatar: "bot-3", wins: 21, losses: 10, draws: 5,
                    last_activity: "Lost, 3 days ago", points: 2},
            %Entry{name: "cool-guy", avatar: "bot-1", wins: 1000, losses: 0, draws: 0,
                    last_activity: "Won, 1 days ago", points: 50},
            %Entry{name: "dweeb", avatar: "bot-4", wins: 1, losses: 1, draws: 20,
                    last_activity: "Draw, 1 days ago", points: 3}
        ]
    end
end 