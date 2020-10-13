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
    field :item_type, Ecto.Enum,
      values: [
        :custom_input,
        :custom_generic_button,
        :custom_generic_button_rounded,
        :custom_text_block,
        :custom_image
      ]
    field :data, :map

    embeds_one :props, Props
    embeds_many :children, Component
  end

  def create_changeset(%__MODULE__{} = module, attrs) do
    attrs = Map.drop(attrs, ["id"])

    changeset(module, attrs)
    |> cast_embed(:children, with: &create_changeset/2)
  end

  def update_changeset(%__MODULE__{} = module, attrs) do
    module
    |> cast(attrs, [
      :item_type
    ])
    |> cast_embed(:props)
    |> cast_embed(:children, with: &update_changeset/2)
    |> validate_required([:id, :item_type, :props, :children])
    |> validate_length(:children, max: 20)
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
