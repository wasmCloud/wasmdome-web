defmodule Wasmdome.Repo do
  use Ecto.Repo,
    otp_app: :wasmdome,
    adapter: Ecto.Adapters.Postgres
end
