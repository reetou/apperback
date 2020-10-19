defmodule Apperback.Project.Page.Component.Props do
  use Ecto.Schema
  use MakeEnumerable
  import Ecto.Changeset

  @derive Jason.Encoder
  embedded_schema do
    field :text, :string, default: ""
    field :disabled, :boolean, default: false
    field :rounded, :boolean, default: false

    field :onClickType, Ecto.Enum,
      values: [:noop, :submit_form, :navigate_replace, :navigate_back, :navigate_push]

    field :newPageId, Ecto.UUID
    field :imageUrl
    field :horizontalAlign, Ecto.Enum, values: [:center, :"flex-start", :"flex-end"]
    field :width, :integer
    field :height, :integer
    field :newPageName, default: ""
    field :backgroundColor
    field :textColor
    field :borderColor
    field :inputPlaceholder, default: ""
    field :borderWidth, :integer
    field :margin, :integer, default: 0
    field :padding, :integer, default: 0
    field :childComponents, {:array, :map}, default: []
    field :noImage, :boolean, default: false
    field :noSubtitle, :boolean, default: false
    field :listItemPrepend, Ecto.Enum, values: [:circle]
    field :fontSize, :integer, default: 14
    field :fontWeight, :integer, default: 400
    field :webPageUrl, :string, default: ""
  end

  def changeset(%__MODULE__{} = module, attrs) do
    module
    |> cast(attrs, [
      :text,
      :disabled,
      :rounded,
      :onClickType,
      :newPageId,
      :imageUrl,
      :horizontalAlign
    ])
    |> validate_length(:text, max: 256)
    |> validate_length(:imageUrl, max: 300)
  end
end
