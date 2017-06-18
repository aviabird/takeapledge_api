# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TakeaplegeApi.Repo.insert!(%TakeaplegeApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

{ :ok, user } =
  TakeaplegeApi.App.create_user(
    %{name: "Pankaj", bio: "Software Developer", password: "123456",
    email: "pankaj@aviabird.com"})

[
  %{
    title: "Local Transport",
    desc: "Utilise public transport as much as possible"},
  %{
    title: "Waste Management",
    desc: "Don't mix wet and dry waste"},
  %{
    title: "Water",
    desc: "Water is life, don't waste it"}
]
|> Enum.map(
  fn attrs ->
    TakeaplegeApi.App.create_category(attrs)
  end
)
|> Enum.map(
  fn { :ok, category } ->
    TakeaplegeApi.Category.create_post(
      %{
        title: "First Post for #{category.title}",content: category.desc,
        user_id: user.id, category_id: category.id}
    )
  end
)

