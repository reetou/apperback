defmodule Apperback.Project.TabbarSettings do
  alias Apperback.Project.Page
  alias Apperback.Project.TabbarItem
  use Ecto.Schema
  use MakeEnumerable
  import Apperback.Helpers
  import Ecto.Changeset
  require Logger

  @derive Jason.Encoder
  embedded_schema do
    field :show_label, :boolean, default: true
    field :color, :string, default: "#FAFAFA"
    field :selected_color, :string, default: "#000000"
    embeds_many :items, TabbarItem
  end

  def changeset(%__MODULE__{} = module, attrs) do
    module
    |> cast(attrs, [
      :show_label,
      :color,
      :selected_color
    ])
    |> cast_embed(:items)
    |> validate_length(:color, max: 30)
    |> validate_length(:selected_color, max: 30)
    |> validate_length(:items, max: 4)
  end
end
