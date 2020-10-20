defmodule Apperback.Project.TabbarItem do
  use Ecto.Schema
  use MakeEnumerable
  import Apperback.Helpers
  import Ecto.Changeset
  require Logger

  @derive {Jason.Encoder, only: [:icon, :label, :id, :page_id]}
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "projects" do
    field :icon, :string, default: "user"
    field :label, :string, default: "Page"
    field :page_id
  end

  def changeset(%__MODULE__{} = module, attrs) do
    module
    |> cast(attrs, [
      :id,
      :icon,
      :label,
      :page_id
    ])
    |> autogenerate_id_if_not_exists()
    |> validate_required([:id, :icon, :label])
    |> validate_length(:label, max: 40)
    |> validate_length(:icon, max: 40)
    |> validate_length(:page_id, max: 256)
  end
end
