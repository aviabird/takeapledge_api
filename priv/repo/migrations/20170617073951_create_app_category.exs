defmodule TakeaplegeApi.Repo.Migrations.CreateTakeaplegeApi.App.Category do
  use Ecto.Migration

  def change do
    create table(:app_categories) do
      add :title, :string
      add :desc, :text

      timestamps()
    end

  end
end
