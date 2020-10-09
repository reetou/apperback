defmodule Apperback.Project.Page do
  alias Apperback.Project.Page.Component
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder,
           only: [:id, :name, :padding, :margin, :page_type, :background_color, :components]}
  @primary_key {:id, :binary_id, autogenerate: true}
  embedded_schema do
    field :name
    field :padding, {:array, :integer}
    field :margin, {:array, :integer}
    field :page_type, Ecto.Enum, values: [:screen, :modal]
    field :background_color, :string, default: "#FFFFFF"
    embeds_many :components, Component
  end

  def changeset(%__MODULE__{} = module, attrs) do
    module
    |> cast(attrs, [
      :name,
      :padding,
      :margin,
      :page_type,
      :background_color
    ])
    |> cast_embed(:components)
    |> validate_required([:name, :padding, :margin, :page_type, :components])
    |> validate_length(:name, min: 3, max: 64)
    |> validate_length(:padding, is: 4)
    |> validate_length(:margin, is: 4)
  end
end
