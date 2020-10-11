defmodule Apperback.User do
  use Ecto.Schema
  use MakeEnumerable
  import Apperback.Helpers
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Jason.Encoder, only: [:id, :email]}
  embedded_schema do
    field :email
  end

  def changeset(module, attrs) do
    module
    |> cast(attrs, [
      :id,
      :email
    ])
    |> validate_required([:id])
  end

  def format(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> apply_action!(:format)
  end

  def get_by(attrs) do
    format(attrs)
  end
end
