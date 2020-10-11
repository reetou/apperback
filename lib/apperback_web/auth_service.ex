defmodule ApperbackWeb.AuthService do
  alias Apperback.User
  alias ApperbackWeb.Auth.UserToken

  def check(nil) do
    :error
  end

  def check(token) do
    {:ok, User.format(%{"id" => Ecto.UUID.generate(), "email" => "email@gmail.com"})}
  end

  def sign(%User{id: id}) do
    UserToken.sign(%{"id" => id})
  end
end
