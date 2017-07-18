defmodule TakeaplegeApi.Category.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias TakeaplegeApi.Category.Post


  schema "category_posts" do
    field :content, :string
    field :title, :string

    belongs_to :user, TakeaplegeApi.App.User
    belongs_to :category, TakeaplegeApi.App.Category
    
    has_many :comments, TakeaplegeApi.Post.Comment

    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:title, :content, :user_id, :category_id])
    |> validate_required([:title, :content, :user_id, :category_id])
  end
end
