defmodule Apperback.Project.Page.Component.Props do
  use Ecto.Schema

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
