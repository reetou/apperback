defmodule Apperback.Project do
  alias Apperback.Project.Page
  use Ecto.Schema
  use MakeEnumerable
  import Apperback.Helpers
  import Ecto.Changeset
  require Logger

  @derive {Jason.Encoder, only: [:id, :project_name, :pages, :user_id]}
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "projects" do
    field :project_name
    field :user_id
    embeds_many :pages, Page
  end

  def collection, do: "projects"

  def create_changeset(%__MODULE__{} = module, attrs) do
    attrs = Map.drop(attrs, ["id", "user_id"])
    changeset(module, attrs)
  end

  def changeset(%__MODULE__{} = module, attrs) do
    module
    |> cast(attrs, [
      :id,
      :project_name,
      :user_id
    ])
    |> autogenerate_id_if_not_exists()
    |> cast_embed(:pages)
    |> validate_required([:id, :project_name, :pages, :user_id])
    |> validate_length(:project_name, min: 3, max: 100)
  end

  def update_changeset(%__MODULE__{} = module, attrs) do
    module
    |> cast(attrs, [
      :project_name
    ])
    |> cast_embed(:pages, with: &Page.update_changeset/2)
    |> validate_required([:project_name, :user_id])
    |> validate_length(:project_name, min: 3, max: 100)
  end

  def update(%__MODULE__{id: id} = module, attrs) do
    data =
      module
      |> update_changeset(attrs)
      |> apply_action!(:update_project)

    :mongo
    |> Mongo.update_one(collection(), %{"id" => id}, %{
      "$set" => data
    })
    |> case do
      {:ok, _} ->
        Mongo.Adapter.get_one_by(%__MODULE__{}, %{"id" => id})

      {:error, _} = error ->
        Logger.error("Cannot update page and changes #{inspect(data)}: #{inspect(error)}")
        error
    end
  end

  def create(%__MODULE__{user_id: user_id} = module, attrs) when is_binary(user_id) do
    module
    |> create_changeset(attrs)
    |> Mongo.Adapter.insert()
  end

  def create_default_project(user_id) do
    create(%__MODULE__{user_id: user_id, pages: List.wrap(Page.default_page())}, %{
      "project_name" => "Default project"
    })
  end

  def get_for_user(user_id, project_id) do
    Mongo.Adapter.get_one_by(%__MODULE__{}, %{user_id: user_id, id: project_id})
  end

  def get(id) do
    Mongo.Adapter.get_one_by(%__MODULE__{}, %{id: id})
  end

  def list(user_id) do
    :mongo
    |> Mongo.find(collection(), %{user_id: user_id})
    |> Enum.map(fn p -> changeset(%__MODULE__{}, p) end)
    |> Enum.map(&apply_changes/1)
    |> Enum.to_list()
  end
end
