defmodule TakeaplegeApi.Category.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias TakeaplegeApi.Category.Post


  schema "category_posts" do
    field :content, :string
    field :title, :string
    field :user_id, :id
    field :category_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:title, :content])
    |> validate_required([:title, :content])
  end
end
