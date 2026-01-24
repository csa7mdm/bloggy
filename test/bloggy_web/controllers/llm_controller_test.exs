defmodule BloggyWeb.LLMControllerTest do
  use BloggyWeb.ConnCase

  test "GET /llms.txt returns plain text content map", %{conn: conn} do
    conn = get(conn, ~p"/llms.txt")

    assert response_content_type(conn, :text)
    assert response = response(conn, 200)
    assert response =~ "# Bloggy Content Map for AI Agents"
  end
end
