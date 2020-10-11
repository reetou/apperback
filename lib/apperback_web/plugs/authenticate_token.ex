defmodule ApperbackWeb.AuthenticateToken do
  @behaviour Plug
  alias ApperbackWeb.AuthService

  import Plug.Conn
  require Logger

  @impl Plug
  def init(opts) do
    opts
  end

  @impl Plug
  def call(conn, opts) do
    conn
    |> authenticate(opts)
  end

  def authenticate(conn, opts) do
    conn
    |> get_req_header("authorization")
    |> get_token(opts)
    |> case do
      {:error, _reason} ->
        set_user(nil, conn)

      {:ok, user} ->
        user
        |> set_user(conn)
    end
  end

  def get_token([], _), do: {:error, "no token found"}

  def get_token(["Bearer " <> token | _], opts),
    do: verify_token(token, opts)

  def get_token([token | _], opts),
    do: verify_token(token, opts)

  defp verify_token(token, opts) do
    token_module = opts[:token_module]
    user_context = opts[:user_context]
    token |> token_module.verify(opts) |> get_user(user_context)
  end

  def set_user(_, %{assigns: %{current_user: current_user}} = conn)
      when not is_nil(current_user),
      do: conn

  def set_user(user, conn), do: assign(conn, :current_user, user)

  def get_user({:ok, data}, user_context) do
    case user_context.get_by(data) do
      nil -> {:error, "no user found"}
      user -> {:ok, user}
    end
  end

  def get_user({:error, message}, _), do: {:error, message}
end
