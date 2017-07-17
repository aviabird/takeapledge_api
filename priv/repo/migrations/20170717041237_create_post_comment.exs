defmodule TakeaplegeApi.Repo.Migrations.CreateTakeaplegeApi.Post.Comment do
  use Ecto.Migration

  def change do
    create table(:post_comments) do
      add :message, :text
      add :user_id, references(:app_users, on_delete: :nothing)
      add :post_id, references(:category_posts, on_delete: :nothing)

      timestamps()
    end

    create index(:post_comments, [:user_id])
    create index(:post_comments, [:post_id])
  end
end
