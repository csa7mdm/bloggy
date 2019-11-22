defmodule BloggyWeb.PageController do
  use BloggyWeb, :controller

  def index(conn, _params) do
    IO.puts("Ana hna hna yabn el 7lal")
    render(conn, "index.html")
  end
end
