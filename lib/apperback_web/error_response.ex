defmodule ApperbackWeb.ErrorResponse do
  use ApperbackWeb, :controller
  alias ApperbackWeb.ErrorView

  def render_error(conn, code, data \\ []) do
    conn
    |> put_view(ErrorView)
    |> put_status(code)
    |> render("#{code}.json", data)
  end
end
