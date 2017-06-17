defmodule TakeaplegeApi.App.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias TakeaplegeApi.App.Category


  schema "app_categories" do
    field :desc, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(%Category{} = category, attrs) do
    category
    |> cast(attrs, [:title, :desc])
    |> validate_required([:title, :desc])
  end
end
