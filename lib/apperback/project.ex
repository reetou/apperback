defmodule Apperback.Project do
  alias Apperback.Project.Page
  use Ecto.Schema
  use MakeEnumerable
  import Apperback.Helpers
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :project_name, :pages]}
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "projects" do
    field :project_name
    embeds_many :pages, Page
  end

  def collection, do: "projects"

  def changeset(%__MODULE__{} = module, attrs) do
    module
    |> cast(attrs, [
      :id,
      :project_name
    ])
    |> autogenerate_id_if_not_exists()
    |> cast_embed(:pages)
    |> validate_required([:id, :project_name, :pages])
    |> validate_length(:project_name, min: 3, max: 100)
  end

  def update_changeset(%__MODULE__{} = module, attrs) do
    module
    |> cast(attrs, [
      :project_name
    ])
    |> validate_required([:project_name])
    |> validate_length(:project_name, min: 3, max: 100)
  end

  def update(%__MODULE__{id: id} = module, attrs) do
    module
    |> update_changeset(attrs)
    |> Mongo.Adapter.update_one_by(%{id: id})
  end

  def create(%__MODULE__{} = module, attrs) do
    module
    |> changeset(attrs)
    |> Mongo.Adapter.insert()
  end

  def create_default_project do
    create(%__MODULE__{pages: List.wrap(Page.default_page())}, %{"project_name" => "Default project"})
  end

  def get(id) do
    Mongo.Adapter.get_one_by(%__MODULE__{}, %{id: id})
  end
end
