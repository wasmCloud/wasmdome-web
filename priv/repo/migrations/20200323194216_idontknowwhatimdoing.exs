defmodule Wasmdome.Repo.Migrations.Idontknowwhatimdoing do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :oauth_id, :string
      modify :account_jwt, :text
    end
  end
end
