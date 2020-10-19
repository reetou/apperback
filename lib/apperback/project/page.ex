defmodule Apperback.Project.Page do
  alias Apperback.Project
  alias Apperback.Project.Page.Component
  use Ecto.Schema
  use MakeEnumerable
  import Ecto.Changeset
  import Apperback.Helpers

  require Logger

  @derive {Jason.Encoder,
           only: [:id, :name, :padding, :margin, :page_type, :background_color, :components]}
  @primary_key {:id, :binary_id, autogenerate: true}
  embedded_schema do
    field :name
    field :padding, {:array, :integer}, default: [0, 0, 0, 0]
    field :margin, {:array, :integer}, default: [0, 0, 0, 0]
    field :page_type, Ecto.Enum, values: [:screen, :modal], default: :screen
    field :nav_header_mode, Ecto.Enum, values: [:show, :hide], default: :show
    field :nav_header_title, :string, default: "Header"
    field :background_color, :string, default: "#FFFFFF"
    field :first_page_id, :string, default: ""
    embeds_many :components, Component
  end

  def create_changeset(%__MODULE__{} = module, attrs) do
    attrs = Map.drop(attrs, ["id"])

    changeset(module, attrs)
    |> cast_embed(:components, with: &Component.create_changeset/2)
  end

  def update_changeset(%__MODULE__{} = module, attrs) do
    module
    |> cast(attrs, [
      :name,
      :padding,
      :margin,
      :page_type,
      :background_color
    ])
    |> cast_embed(:components, with: &Component.create_changeset/2)
    |> validate()
  end

  def changeset(%__MODULE__{} = module, attrs) do
    module
    |> cast(attrs, [
      :id,
      :name,
      :padding,
      :margin,
      :page_type,
      :background_color
    ])
    |> autogenerate_id_if_not_exists()
    |> cast_embed(:components)
    |> validate_required([:id, :name, :padding, :margin, :page_type, :components])
    |> validate()
  end

  def default_page do
    %__MODULE__{
      id: Ecto.UUID.generate(),
      name: "Default Page",
      padding: [0, 0, 0, 0],
      margin: [0, 0, 0, 0],
      components: []
    }
    |> changeset(%{})
    |> apply_action!(:default_page)
  end

  def update(%__MODULE__{id: id} = module, project_id, attrs) do
    data =
      module
      |> update_changeset(attrs)
      |> apply_action!(:update_page)

    Mongo.update_one(:mongo, Project.collection(), %{"id" => project_id, "pages.id" => id}, %{
      "$set" => %{
        "pages.$" => data
      }
    })
    |> case do
      {:ok, _} ->
        Mongo.Adapter.get_one_by(%Project{}, %{"id" => project_id})

      {:error, _} = error ->
        Logger.error("Cannot update page and changes #{inspect(data)}: #{inspect(error)}")
        error
    end
  end

  def create(project_id, attrs) do
    %__MODULE__{id: id} =
      data =
      %__MODULE__{}
      |> create_changeset(attrs)
      |> apply_action!(:create_page)

    Mongo.update_one(:mongo, Project.collection(), %{"id" => project_id}, %{
      "$addToSet" => %{
        "pages" => data
      }
    })
    |> case do
      {:ok, _} ->
        Mongo.Adapter.get_one_by(%Project{}, %{"id" => project_id})

      {:error, _} = error ->
        Logger.error("Cannot update page and changes #{inspect(data)}: #{inspect(error)}")
        error
    end
  end

  def get(project_id, id) do
    %Project{}
    |> Mongo.Adapter.get_one_by(%{id: project_id})
    |> from_project(id)
  end

  defp validate(changeset) do
    changeset
    |> validate_length(:name, min: 3, max: 64)
    |> validate_length(:padding, is: 4)
    |> validate_length(:margin, is: 4)
  end

  def from_project(%Project{pages: pages}, id) do
    Enum.find(pages, fn %__MODULE__{id: page_id} ->
      page_id == id
    end)
  end
end
