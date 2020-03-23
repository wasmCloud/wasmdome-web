defmodule Wasmdome.Users do
    alias Wasmdome.Repo
    alias Wasmdome.Users.User

    def get_user(id) do
        Repo.get(User, id)
    end

    def get_user_by_oauth(oauth_id) do
        Repo.get_by(User, oauth_id: oauth_id)
    end

    def list_users do
        Repo.all(User)
    end
end 