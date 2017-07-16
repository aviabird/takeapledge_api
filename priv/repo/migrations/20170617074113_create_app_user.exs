defmodule TakeaplegeApi.Repo.Migrations.CreateTakeaplegeApi.App.User do
  use Ecto.Migration

  def change do
    create table(:app_users) do
      add :email, :string
      add :password_hash, :string
      add :name, :string
      add :bio, :text

      timestamps()
    end

    create unique_index(:app_users, [:email])

  end
end
