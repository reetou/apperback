defmodule ApperbackWeb.HealthCheckController do
  @moduledoc false
  use ApperbackWeb, :controller
  alias Apperback.Configuration

  def index(conn, _) do
    Configuration.test_db()
    json(conn, %{status: "I'm fine thank you!"})
  end
end
