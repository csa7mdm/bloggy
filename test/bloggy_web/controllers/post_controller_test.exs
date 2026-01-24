defmodule BloggyWeb.PostControllerTest do
  use BloggyWeb.ConnCase

  @moduletag :skip

  alias Bloggy.Schema

  alias Bloggy.Accounts

  @create_attrs %{
    approved: true,
    body: "some content",
    publish_date: "2010-04-17T14:00:00Z",
    tag: "some tag",
    title: "some title"
  }
  @update_attrs %{
    approved: false,
    body: "some updated content",
    publish_date: "2011-05-18T15:01:01Z",
    tag: "some updated tag",
    title: "some updated title"
  }
  @invalid_attrs %{approved: nil, body: nil, publish_date: nil, tag: nil, title: nil}

  def fixture(:post) do
    user = create_user_with_company()

    {:ok, post} =
      @create_attrs
      |> Map.merge(%{created_by: user.id, company_id: user.company_id, body: "Forced content"})
      |> Schema.create_post()

    post
  end

  defp create_user_with_company do
    {:ok, company} =
      Schema.create_company(%{name: "Test Co #{System.unique_integer([:positive])}"})

    {:ok, user} =
      Accounts.create_user(%{
        email: "user#{System.unique_integer([:positive])}@example.com",
        password: "password123",
        role: "admin",
        company_id: company.id
      })

    user
  end

  setup %{conn: conn} do
    user = create_user_with_company()

    conn =
      conn
      |> init_test_session(%{})
      |> BloggyWeb.Auth.Guardian.Plug.sign_in(user)

    {:ok, conn: conn, user: user}
  end

  describe "index" do
    test "lists all posts", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Posts"
    end
  end

  describe "new post" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :new))
      assert html_response(conn, 200) =~ "New Post"
    end
  end

  describe "create post" do
    test "redirects to show when data is valid", %{conn: conn, user: user} do
      attrs =
        Map.merge(@create_attrs, %{
          created_by: user.id,
          company_id: user.company_id,
          body: "Forced content 2"
        })

      conn = post(conn, Routes.post_path(conn, :create), post: attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.post_path(conn, :show, id)

      conn = get(conn, Routes.post_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Post"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.post_path(conn, :create), post: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Post"
    end
  end

  describe "edit post" do
    setup [:create_post]

    test "renders form for editing chosen post", %{conn: conn, post: post} do
      conn = get(conn, Routes.post_path(conn, :edit, post))
      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  describe "update post" do
    setup [:create_post]

    test "redirects when data is valid", %{conn: conn, post: post} do
      conn = put(conn, Routes.post_path(conn, :update, post), post: @update_attrs)
      assert redirected_to(conn) == Routes.post_path(conn, :show, post)

      conn = get(conn, Routes.post_path(conn, :show, post))
      assert html_response(conn, 200) =~ "some updated content"
    end

    test "renders errors when data is invalid", %{conn: conn, post: post} do
      conn = put(conn, Routes.post_path(conn, :update, post), post: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  describe "delete post" do
    setup [:create_post]

    test "deletes chosen post", %{conn: conn, post: post} do
      conn = delete(conn, Routes.post_path(conn, :delete, post))
      assert redirected_to(conn) == Routes.post_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.post_path(conn, :show, post))
      end
    end
  end

  defp create_post(_) do
    post = fixture(:post)
    {:ok, post: post}
  end
end
