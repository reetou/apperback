defmodule ApperbackWeb.AuthController do
  alias ApperbackWeb.AuthService
  alias Apperback.User
  alias ApperbackWeb.ErrorResponse

  use ApperbackWeb, :controller

  def check(%{assigns: %{current_user: %User{} = user}} = conn, _) do
    json(conn, %{user: user})
  end

  def sign(%{assigns: %{current_user: %User{}}} = conn, _) do
    ErrorResponse.render_error(conn, 400, detail: "Already authenticated")
  end

  def sign(conn, %{"token" => token}) do
    {:ok, user} = AuthService.check(token)
    token = AuthService.sign(user)
    json(conn, %{user: user, token: token})
  end
end
