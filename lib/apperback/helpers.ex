defmodule Apperback.Helpers do
  import Ecto.Changeset
  require Logger

  def autogenerate_id_if_not_exists(%Ecto.Changeset{data: %{id: id}} = changeset) when not is_nil(id), do: changeset
  def autogenerate_id_if_not_exists(%Ecto.Changeset{changes: %{id: id}} = changeset) when not is_nil(id), do: changeset

  def autogenerate_id_if_not_exists(%Ecto.Changeset{changes: %{}} = changeset) do
    Logger.info("Autogenerating id for changeset #{inspect changeset}")
    changeset
    |> cast(%{id: Ecto.UUID.autogenerate()}, [:id])
  end
end