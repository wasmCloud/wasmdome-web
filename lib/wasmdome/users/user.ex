defmodule Wasmdome.Users.User do
    use Ecto.Schema
    import Ecto.Changeset

    schema "users" do
        field :displayname, :string
        field :account_jwt, :string
        field :oauth_id,    :string

        timestamps()
    end
end