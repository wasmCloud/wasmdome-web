defmodule Core.Mech do
    @initial_health 1000

    defstruct ~w(
        name
        position
        avatar
        team
        pk
        health
    )a

    def new(pk, opts \\ []) do
        %__MODULE__{
            pk: pk,
            position: Keyword.get(opts, :position, {0,0}),
            avatar: Keyword.get(opts, :avatar, "none"),
            name: Keyword.get(opts, :name, "none"),
            team: Keyword.get(opts, :team, "earth"),
            health: Keyword.get(opts, :health, @initial_health)
        }        
    end

    def take_damage(mech, dmg) do        
        put_in(mech.health, mech.health - dmg)
    end

    def destroy(mech) do
        put_in(mech.health, 0)
    end

    def to_gridpiece(nil, _board) do
        :empty
    end

    # On a 24x24 board, the domain model origin 0,0 is the bottom left corner
    # Bottom left corner on a user-facing board is x:max, y:max
    # valid positions are 0..x:max-1, 0..y:max-1
    def to_gridpiece(mech, board) do        
        %Core.Gridpiece{
            column: board.width - elem(mech.position, 0)-1,
            row: board.height - elem(mech.position, 1)-1,
            avatar: "#{mech.avatar}-#{mech.team}"
        }
    end    
end