defmodule Wasmdome.Users do
    alias Wasmdome.Repo
    alias Wasmdome.Users.User

    def get_user(id) do
        Repo.get(User, id)
    end
    
    def get_user_for_oauth(token) do
        IO.inspect token
        profile = Repo.get_by(User, oauth_id: token.id)
        if !profile do
            case Repo.insert %User{ oauth_id: token.id, displayname: "New User", account_jwt: ""} do 
                {:ok, user} -> user
                {:error, _changeset} -> nil
            end        
        else
            profile
        end        
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