defmodule Mongo.Adapter do
  import Ecto.Changeset
  require Logger

  def insert(changeset) do
    changeset
    |> apply_action(:create)
    |> case do
      {:ok, data} ->
        %{id: id} =
          data =
          data
          |> Map.drop([:__meta__])

        Mongo.insert_one(:mongo, collection(data), data)
        Logger.debug("Inserted")
        get_one_by(changeset.data, %{id: id})

      {:error, _} = error ->
        Logger.error("Cannot insert #{inspect(changeset)}: #{inspect(error)}")
        error
    end
  end

  def update_one_by(changeset, query, coll \\ nil)

  def update_one_by(%Ecto.Changeset{changes: changes} = changeset, %{id: id} = query, coll)
      when changes == %{} do
    get_one_by(changeset.data, query, coll)
  end

  def update_one_by(%Ecto.Changeset{changes: changes} = changeset, %{id: id} = query, coll) do
    :mongo
    |> Mongo.update_one(collection(changeset.data, coll), query, %{
      "$set" => changes
    })
    |> case do
      {:ok, _} ->
        get_one_by(changeset.data, query, coll)

      {:error, _} = error ->
        Logger.error(
          "Cannot update by query #{inspect(query)} and changes #{inspect(changes)} with module #{
            inspect(changeset)
          }: #{inspect(error)}"
        )

        error
    end
  end

  def get_one_by(%{} = module, %{} = query, coll \\ nil) do
    :mongo
    |> Mongo.find_one(collection(module, coll), query)
    |> case do
      nil ->
        nil

      %{"_id" => _} = data ->
        module
        |> get_changeset(data)
        |> apply_changes()

      {:error, _} = error ->
        Logger.error(
          "Cannot get by query #{inspect(query)} with module #{inspect(module)}: #{inspect(error)}"
        )

        error
    end
  end

  defp collection(%{__struct__: struct}, coll \\ nil) do
    case coll do
      nil -> struct.collection()
      x when is_binary(x) -> x
    end
  end

  defp get_changeset(%{__struct__: struct}, %{} = data) do
    struct.changeset(struct(struct, %{}), data)
  end
end
