defmodule Apperback.Project do
  alias Apperback.Project.Page
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :project_name, :pages]}
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "projects" do
    field :project_name
    embeds_many :pages, Page
  end

  def changeset(%__MODULE__{} = module, attrs) do
    module
    |> cast(attrs, [
      :project_name
    ])
    |> cast_embed(:pages)
    |> validate_required([:project_name, :pages])
    |> validate_length(:project_name, min: 3, max: 100)
  end
end
