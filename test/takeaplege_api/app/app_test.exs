defmodule TakeaplegeApi.AppTest do
  use TakeaplegeApi.DataCase

  alias TakeaplegeApi.App

  describe "categories" do
    alias TakeaplegeApi.App.Category

    @valid_attrs %{desc: "some desc", title: "some title"}
    @update_attrs %{desc: "some updated desc", title: "some updated title"}
    @invalid_attrs %{desc: nil, title: nil}

    def category_fixture(attrs \\ %{}) do
      {:ok, category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> App.create_category()

      category
    end

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert App.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert App.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      assert {:ok, %Category{} = category} = App.create_category(@valid_attrs)
      assert category.desc == "some desc"
      assert category.title == "some title"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = App.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      assert {:ok, category} = App.update_category(category, @update_attrs)
      assert %Category{} = category
      assert category.desc == "some updated desc"
      assert category.title == "some updated title"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = App.update_category(category, @invalid_attrs)
      assert category == App.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = App.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> App.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = App.change_category(category)
    end
  end

  describe "users" do
    alias TakeaplegeApi.App.User

    @valid_attrs %{
      email: "new_user@aviabird.com",
      password: "newpass",
      name: "New User",
      bio: "Software Developer"
    }
    @update_attrs %{
      email: "updated_user@aviabird.com",
      password: "updatepass",
      name: "Updated User",
      bio: "Senior Software Developer"
    }
    @invalid_attrs %{email: nil, password: nil, name: nil, bio: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> App.create_user()

      Map.put(user, :password, nil)
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert App.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert App.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = App.create_user(@valid_attrs)
      assert user.email == "new_user@aviabird.com"
      assert user.name == "New User"
      assert user.bio == "Software Developer"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{errors: errors}} = App.create_user(@invalid_attrs)
      
      [:email, :name, :bio]
        |> Enum.map(
          &(assert "can't be blank" == errors[&1] |> elem(0))
        )
    end

    test "create_user/1, changeset, email invalid format" do
      changeset = User.changeset(
        %User{}, Map.put(@valid_attrs, :email, "foo.com")
      )
      refute changeset.valid?
    end

    test "create_user/1, registration_changeset" do
      changeset = User.registration_changeset(%User{}, @valid_attrs)
      assert changeset.changes.password_hash
      assert changeset.valid?
    end

    test "create_user/1, registration_changeset, password too short" do
      changeset = User.registration_changeset(
        %User{}, Map.put(@valid_attrs, :password, "12345")
      )
      refute changeset.valid?
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = App.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "updated_user@aviabird.com"
      assert user.name == "Updated User"
      assert user.bio == "Senior Software Developer"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = App.update_user(user, @invalid_attrs)
      assert user == App.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = App.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> App.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = App.change_user(user)
    end
  end

  describe "sessions" do
    alias TakeaplegeApi.App.Session

    @valid_attrs %{
      "email" => "test@aviabird.com", "password" => "s3cr3t",
      "name" => "Test", "bio" =>"Test"}
    @invalid_attrs %{}

    def session_fixture(attrs \\ nil) do
      # create user for whom the session will be created
      {:ok, user} = App.create_user(attrs || @valid_attrs)
      user
    end

    test "create_session/1 with valid data creates a session" do
      session_fixture()
      assert {:ok, %Session{} = _} = App.create_session(@valid_attrs)
    end

    test "create_session/1 with invalid data returns error changeset" do
      assert {:error, @invalid_attrs} = App.create_session(@invalid_attrs)
    end
  end
end
