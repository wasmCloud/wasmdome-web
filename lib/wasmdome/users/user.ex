defmodule Wasmdome.Users.User do
    use Ecto.Schema
    import Ecto.Changeset

    schema "users" do
        field :displayname, :string
        field :account_jwt, :string
        field :oauth_id,    :string

        timestamps()
    end

    def changeset(user, attrs) do
        user
        |> cast(attrs, [:displayname, :account_jwt])
        |> validate_required([:displayname, :account_jwt])
    end
end