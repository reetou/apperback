defmodule Apperback.Project.Page do
  alias Apperback.Project.Page.Component
  use Ecto.Schema
  use MakeEnumerable
  import Ecto.Changeset
  import Apperback.Helpers

  @derive {Jason.Encoder,
           only: [:id, :name, :padding, :margin, :page_type, :background_color, :components]}
  @primary_key {:id, :binary_id, autogenerate: true}
  embedded_schema do
    field :name
    field :padding, {:array, :integer}, default: [0, 0, 0, 0]
    field :margin, {:array, :integer}, default: [0, 0, 0, 0]
    field :page_type, Ecto.Enum, values: [:screen, :modal], default: :screen
    field :background_color, :string, default: "#FFFFFF"
    embeds_many :components, Component
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
    |> validate_length(:name, min: 3, max: 64)
    |> validate_length(:padding, is: 4)
    |> validate_length(:margin, is: 4)
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
end
