defmodule Wasmdome.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :displayname, :string
      add :account_jwt, :string
      add :oauth_id, :string

      timestamps()
    end

    create unique_index(:users, [:oauth_id])
  end
end
