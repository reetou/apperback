defmodule Apperback.Project.Page.Component.Data do
  use Ecto.Schema
  use MakeEnumerable
  import Ecto.Changeset

  @derive Jason.Encoder
  embedded_schema do
    field :value, :string, default: ""
    field :childComponents, {:array, :map}, default: []
  end

  def changeset(%__MODULE__{} = module, attrs) do
    module
    |> cast(attrs, [
      :value,
      :childComponents
    ])
    |> validate_length(:value, max: 256)
    |> validate_length(:childComponents, max: 20)
  end
end
