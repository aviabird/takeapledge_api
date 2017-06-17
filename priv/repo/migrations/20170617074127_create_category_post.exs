defmodule TakeaplegeApi.Repo.Migrations.CreateTakeaplegeApi.Category.Post do
  use Ecto.Migration

  def change do
    create table(:category_posts) do
      add :title, :string
      add :content, :text
      add :user_id, references(:app_users, on_delete: :nothing)
      add :category_id, references(:app_categories, on_delete: :nothing)

      timestamps()
    end

    create index(:category_posts, [:user_id])
    create index(:category_posts, [:category_id])
  end
end
