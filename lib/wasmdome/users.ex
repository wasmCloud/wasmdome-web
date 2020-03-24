defmodule Wasmdome.Users do
    alias Wasmdome.Repo
    alias Wasmdome.Users.User

    def get_user(id) do
        Repo.get(User, id)
    end
    
    def get_user_for_oauth(token) do
        Repo.get_by(User, oauth_id: token.id)
    end

    def list_users do
        Repo.all(User)
    end    

    def change_user(%User{} = user) do
        User.changeset(user, %{})
      end
      
    
    def update_user(%User{} = user, attrs \\ %{}) do
        user
        |> User.changeset(attrs)
        |> Repo.update()
    end
    
end 