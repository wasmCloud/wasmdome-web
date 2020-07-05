defmodule Wasmdome.ScheduledMatches.Match do
    defstruct [:board_height, :board_width, :max_mechs, :max_turns, :starts_in_friendly, :starts_in_mins, :current_mechs, :id, :aps_per_turn, :turn]
end