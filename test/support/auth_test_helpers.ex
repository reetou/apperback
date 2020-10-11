defmodule ApperbackWeb.AuthTestHelpers do
  use Phoenix.ConnTest
  alias ApperbackWeb.Auth.UserToken
  alias Apperback.User

  def add_user_token(conn, %{} = data) do
    user_token = UserToken.sign(data)

    conn
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", user_token)
  end

  def add_user(%{conn: conn} = ctx) do
    Map.put(ctx, :user, %User{id: Ecto.UUID.generate(), email: "some@gmail.com"})
  end

  def setup_user_conn(%{conn: conn, user: %User{id: id}} = ctx) do
    Map.put(ctx, :conn, add_user_token(conn, %{"id" => id}))
  end

  def setup_user_conn(%{conn: conn} = ctx) do
    ctx
    |> add_user()
    |> setup_user_conn()
  end
end
