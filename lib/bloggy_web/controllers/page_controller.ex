defmodule BloggyWeb.PageController do
  use BloggyWeb, :controller

  def home(conn, _params) do
    render(conn, :home, layout: false)
  end
end
