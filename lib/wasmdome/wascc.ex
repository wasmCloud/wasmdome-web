defmodule Wasmdome.Wascc do
    use Rustler, otp_app: :wasmdome, crate: "wasmdome_wascc"

    def decode_jwt(_jwt), do: :erlang.nif_error(:nif_not_loaded)
    
    def validate_jwt(_jwt), do: :erlang.nif_error(:nif_not_loaded)

    def extract_jwt(_bytes), do: :erlang.nif_error(:nif_not_loaded)

    def lattice_inventory(), do: :erlang.nif_error(:nif_not_loaded)
end