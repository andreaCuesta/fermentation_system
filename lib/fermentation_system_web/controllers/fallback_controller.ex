defmodule FermentationSystemWeb.FallbackController do
  use FermentationSystemWeb, :controller

  alias FermentationSystemWeb.ErrorView

  @spec call(conn :: Plug.Conn.t(), changeset :: Ecto.Changeset.t()) :: map()
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ErrorView)
    |> render("error.json", changeset_errors: changeset)
  end
end