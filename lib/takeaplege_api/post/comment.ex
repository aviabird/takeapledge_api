defmodule TakeaplegeApi.Post.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias TakeaplegeApi.Post.Comment


  schema "post_comments" do
    field :message, :string

    belongs_to :user, TakeaplegeApi.App.User
    belongs_to :post, TakeaplegeApi.Category.Post

    timestamps()
  end

  @doc false
  def changeset(%Comment{} = comment, attrs) do
    comment
    |> cast(attrs, ~w(message user_id post_id))
    |> validate_required([:message, :user_id, :post_id])
  end
end
