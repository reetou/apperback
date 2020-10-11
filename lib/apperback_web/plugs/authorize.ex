defmodule ApperbackWeb.Plugs.Authorize do
  @moduledoc """
  Functions to help with authorization.

  See the [Authorization wiki page](https://github.com/riverrun/phauxth/wiki/Authorization)
  for more information and examples about authorization.
  """

  import Plug.Conn
  import Phoenix.Controller
  alias ApperbackWeb.ErrorResponse
  alias Apperback.User

  @doc """
  Plug to only allow authenticated users to access the resource.

  See the user controller for an example.
  """
  def user_check(%Plug.Conn{assigns: %{current_user: nil}} = conn, _opts) do
    conn
    |> ErrorResponse.render_error(401)
    |> halt()
  end

  def user_check(conn, _opts), do: conn
end
