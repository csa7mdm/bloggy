defmodule BloggyWeb.Auth.CurrentUser do
  import Plug.Conn
  import Guardian.Plug

  def init(opts), do: opts

  def call(conn, _opts) do
    IO.inspect(conn, label: "This is the label")
    current_user = current_resource(conn)
    assign(conn, :current_user, current_user)
  end
end
