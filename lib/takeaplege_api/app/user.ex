defmodule TakeaplegeApi.App.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias TakeaplegeApi.App.User


  schema "app_users" do
    field :email, :string
    field :password, :string
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password_hash, :password])
    |> validate_required([:email, :password_hash, :password])
  end
end
