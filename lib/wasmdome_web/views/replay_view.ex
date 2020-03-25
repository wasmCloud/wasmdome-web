defmodule WasmdomeWeb.ReplayView do
    use WasmdomeWeb, :view

    def progress_color(health) do
        cond do
            health > 600 -> "bg-success"
            health > 300 -> "bg-warning"
            true -> "bg-danger"
        end        
    end

    def progress_width(health) do
        round(health / 1000 * 100)
    end
end
  