defmodule BloggyWeb.Auth.ErrorHandler do
  import Plug.Conn

  def auth_error(conn, {type, _reason}, _opts) do
    IO.puts("We are here heeeeeeh5")
    # IO.inspect(conn)
    IO.inspect(_reason)
    body = Poison.encode!(%{error: to_string(type)})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, body)
  end
end
