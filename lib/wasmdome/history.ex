defmodule Wasmdome.History do
    @moduledoc """
    The history context
    """

    alias Wasmdome.History.MatchSummary

    def match_history do        
        [
          %MatchSummary{winner: {"Kevin", "bot-1"}, avatars: [
                    {"Kevin", "bot-1"}, 
                    {"Bob", "bot-2"}, 
                    {"Al", "bot-3"}, 
                    {"Steve", "bot-4"}
                    ], match_id: "45", turns_used: 24, max_turns: 100, executed_on: "3 hours ago"},  
        %MatchSummary{winner: {"Bob", "bot-2"}, avatars: [
            {"Kevin", "bot-1"}, 
            {"Bob", "bot-2"}], match_id: "45", turns_used: 24, max_turns: 100, executed_on: "Yesterday"}, 
            %MatchSummary{winner: {"Kevin", "bot-1"}, avatars: [
                {"Kevin", "bot-1"}, 
                {"Bob", "bot-2"}, 
                {"Al", "bot-3"}, 
                {"Steve", "bot-4"}
                ], match_id: "45", turns_used: 24, max_turns: 100, executed_on: "2 days ago"},           
        ]
    end
end 

# defstruct [:winner, :avatars, :match_id, :max_turns, :turns_used, :executed_on]