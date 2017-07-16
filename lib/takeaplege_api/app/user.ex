defmodule TakeaplegeApi.App.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias TakeaplegeApi.App.User
  alias Comeonin.Bcrypt

  schema "app_users" do
    field :email, :string
    field :name, :string
    field :bio, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @email_reg ~r/[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}/

  @doc false
  def changeset(%User{} = user, attrs \\ :empty) do
    user
    |> cast(attrs, ~w(email name bio))
    |> validate_required([:email, :name, :bio])
    |> validate_format(:email, @email_reg)
    |> unique_constraint(:email)
  end

  def registration_changeset(%User{} = user, attrs \\ :empty) do
    user
    |> changeset(attrs)
    |> cast(attrs, ~w(password))
    |> validate_required([:password])
    |> validate_length(:password, min: 6)
    |> put_password_hash
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{
        valid?: true, changes: %{password: pass}
      } -> put_change(
        changeset, :password_hash, Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
