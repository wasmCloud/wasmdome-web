defmodule Wasmdome.Repo.Migrations.WidenOauthId do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :oauth_id, :text
    end
  end
end
