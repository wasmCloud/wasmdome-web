defmodule Wasmdome.Mechs do
    @moduledoc """
    The "my mechs" context
    """

    alias Wasmdome.Mechs.Mech

    def my_mechs(user_id) do
        IO.inspect user_id
        [
            %Mech{name: "Kevin's Bot", avatar: "bot-1", matches: 1200, kills: 24, deaths: 5, points: 4500, revision: 5, subject: "MASCXFM4R6X63UD5MSCDZYCJNPBVSIU6RKMXUPXRKAOSBQ6UY3VT3NPZ" },
            %Mech{name: "Brooks's Bot", avatar: "bot-2", matches: 1200, kills: 24, deaths: 5, points: 4500, revision: 5, subject: "MASCXFM4R6X63UD5MSCDZYCJNPBVSIU6RKMXUPXRKAOSBQ6UY3VT3NPZ" },
            %Mech{name: "Bob's Bot", avatar: "bot-3", matches: 1200, kills: 24, deaths: 5, points: 4500, revision: 5, subject: "MASCXFM4R6X63UD5MSCDZYCJNPBVSIU6RKMXUPXRKAOSBQ6UY3VT3NPZ" },
            %Mech{name: "Al's Bot", avatar: "bot-4", matches: 1200, kills: 24, deaths: 5, points: 4500, revision: 5, subject: "MASCXFM4R6X63UD5MSCDZYCJNPBVSIU6RKMXUPXRKAOSBQ6UY3VT3NPZ" },
            %Mech{name: "Steve's Bot", avatar: "bot-5", matches: 1200, kills: 24, deaths: 5, points: 4500, revision: 5, subject: "MASCXFM4R6X63UD5MSCDZYCJNPBVSIU6RKMXUPXRKAOSBQ6UY3VT3NPZ" },
            %Mech{name: "Alice's Bot", avatar: "bot-6", matches: 1200, kills: 24, deaths: 5, points: 4500, revision: 5, subject: "MASCXFM4R6X63UD5MSCDZYCJNPBVSIU6RKMXUPXRKAOSBQ6UY3VT3NPZ" },
            %Mech{name: "Foo's Bot", avatar: "bot-7", matches: 1200, kills: 24, deaths: 5, points: 4500, revision: 5, subject: "MASCXFM4R6X63UD5MSCDZYCJNPBVSIU6RKMXUPXRKAOSBQ6UY3VT3NPZ" },
        ]
    end
end 