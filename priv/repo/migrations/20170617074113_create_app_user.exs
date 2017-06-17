defmodule TakeaplegeApi.Repo.Migrations.CreateTakeaplegeApi.App.User do
  use Ecto.Migration

  def change do
    create table(:app_users) do
      add :email, :string
      add :password_hash, :string
      add :password, :string

      timestamps()
    end

  end
end
