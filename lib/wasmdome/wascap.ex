defmodule Wasmdome.Wascap do
    use Rustler, otp_app: :wasmdome, crate: "wasmdome_wascap"

    def decode_jwt(_jwt), do: :erlang.nif_error(:nif_not_loaded)
    
    def validate_jwt(_jwt), do: :erlang.nif_error(:nif_not_loaded)
end