defmodule FermentationSystemWeb.CORS do
  @moduledoc false

  allowed_origins = Application.get_env(:fermentation_system, :allowed_origins)

  use Corsica.Router,
      origins: [allowed_origins],
      allow_credentials: true,
      allow_headers: [
        "authorization",
        "x-requested-with",
        "content-disposition",
        "content-type",
        "client-id",
        "grant-type",
        "client-secret",
        "client_id",
        "client_secret",
        "grant_type"
      ]

  resource("/*", origins: "*")
end