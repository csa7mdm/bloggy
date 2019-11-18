defmodule BloggyWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline, otp_app: :bloggy,
    module: BloggyWeb.Auth.Guardian,
    error_handler: BloggyWeb.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
