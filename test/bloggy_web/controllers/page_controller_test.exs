defmodule BloggyWeb.PageControllerTest do
  use BloggyWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Bloggy"
  end
end
