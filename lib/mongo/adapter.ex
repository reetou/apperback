defmodule Mongo.Adapter do
  import Ecto.Changeset
  require Logger

  def insert(changeset) do
    changeset
    |> apply_action(:create)
    |> case do
         {:ok, data} ->
           %{id: id} = data =
             data
             |> Map.drop([:__meta__])
           Mongo.insert_one(:mongo, collection(data), data)
           Logger.debug("Inserted")
           get_one_by(changeset.data, %{id: id})
         {:error, _} = error ->
           Logger.error("Cannot insert #{inspect changeset}: #{inspect error}")
           error
       end
  end

  def update_one_by(%Ecto.Changeset{changes: changes} = changeset, %{id: id} = query) do
    :mongo
    |> Mongo.update_one(collection(changeset.data), query, %{
      "$set" => changes
    })
    |> case do
        {:ok, _} ->
          get_one_by(changeset.data, query)
        {:error, _} = error ->
          Logger.error("Cannot update by query #{inspect query} and changes #{inspect changes} with module #{inspect changeset}: #{inspect error}")
          error
       end
  end

  def get_one_by(%{} = module, %{} = query) do
    :mongo
    |> Mongo.find_one(collection(module), query)
    |> case do
         nil -> nil
         %{"_id" => _} = data ->
           module
           |> get_changeset(data)
           |> apply_changes()
           {:error, _} = error ->
             Logger.error("Cannot get by query #{inspect query} with module #{inspect module}: #{inspect error}")
             error
       end
  end

  defp collection(%{__struct__: struct}) do
    struct.collection()
  end

  defp get_changeset(%{__struct__: struct}, %{} = data) do
    struct.changeset(struct(struct, %{}), data)
  end

end