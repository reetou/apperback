defmodule Apperback.Project.Page.Component do
  alias Apperback.Project.Page.Component
  alias Apperback.Project.Page.Component.Props

  use MakeEnumerable
  use Ecto.Schema
  import Apperback.Helpers
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :item_type, :props, :children]}
  @primary_key {:id, :binary_id, autogenerate: true}
  embedded_schema do
    field :item_type, Ecto.Enum, values: [
      :custom_input,
      :custom_generic_button,
      :custom_generic_button_rounded,
      :custom_text_block,
      :custom_image
    ]

    embeds_one :props, Props
    embeds_many :children, Component
  end

  def changeset(%__MODULE__{} = module, attrs) do
    module
    |> cast(attrs, [
      :id,
      :item_type
    ])
    |> autogenerate_id_if_not_exists()
    |> cast_embed(:props)
    |> cast_embed(:children)
    |> validate_required([:id, :item_type, :props, :children])
    |> validate_length(:children, max: 20)
  end
end
