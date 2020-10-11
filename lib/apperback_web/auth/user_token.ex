defmodule ApperbackWeb.Auth.UserToken do
  alias Phoenix.Token
  alias ApperbackWeb.Endpoint

  def salt do
    "asdas123gdfklasd"
  end

  def sign(data, opts \\ []) do
    Token.sign(Endpoint, salt(), data, opts)
  end

  def verify(token, opts \\ []) do
    Token.verify(Endpoint, salt(), token, opts)
  end
end
