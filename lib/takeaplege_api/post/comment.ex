defmodule TakeaplegeApi.Post.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias TakeaplegeApi.Post.Comment


  schema "post_comments" do
    field :message, :string
    field :user_id, :id
    field :post_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Comment{} = comment, attrs) do
    comment
    |> cast(attrs, [:message])
    |> validate_required([:message])
  end
end
