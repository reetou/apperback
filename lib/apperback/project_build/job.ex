defmodule Apperback.ProjectBuild.Job do
  use Ecto.Schema
  use MakeEnumerable
  import Ecto.Changeset
  import Apperback.Helpers
  alias Mongo.Adapter

  require Logger

  @derive {Jason.Encoder, only: [:id, :name, :status, :duration, :started_at, :finished_at]}
  @primary_key {:id, :id, autogenerate: false}
  embedded_schema do
    field :name
    field :status
    field :duration, :float
    field :project_id
    field :created_at, :utc_datetime
    field :started_at, :utc_datetime
    field :finished_at, :utc_datetime
    field :web_url
  end

  def collection, do: "jobs"

  def changeset(%__MODULE__{} = module, attrs) do
    module
    |> cast(attrs, [
      :id,
      :name,
      :status,
      :duration,
      :created_at,
      :started_at,
      :finished_at,
      :project_id,
      :web_url
    ])
    |> validate_required([
      :id,
      :name,
      :status,
      :duration,
      :created_at,
      :started_at,
      :finished_at,
      :web_url,
      :project_id
    ])
  end

  def format(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> apply_changes()
  end

  def assign_project(%__MODULE__{} = job, project_id) do
    Map.put(job, :project_id, project_id)
  end

  def store(%__MODULE__{project_id: project_id, id: id} = job) when is_binary(project_id) do
    data = Map.drop(job, [:__meta__])
    Mongo.insert_one(:mongo, collection(), data)
    Logger.debug("Inserted job")
    %__MODULE__{} = data = Mongo.Adapter.get_one_by(%__MODULE__{}, %{"id" => id})
    Logger.debug("Finished store job for project #{project_id}")
    data
  end
end
