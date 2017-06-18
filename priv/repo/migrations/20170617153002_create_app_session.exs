defmodule TakeaplegeApi.Repo.Migrations.CreateTakeaplegeApi.App.Session do
  use Ecto.Migration

  def change do
    create table(:app_sessions) do
      add :token, :string
      add :user_id, references(:app_users, on_delete: :nothing)

      timestamps()
    end

    create index(:app_sessions, [:user_id])
    create index(:app_sessions, [:token])
  end
end
