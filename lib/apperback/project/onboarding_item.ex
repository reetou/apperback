defmodule Apperback.Project.OnboardingItem do
  use Ecto.Schema
  use MakeEnumerable
  import Apperback.Helpers
  import Ecto.Changeset
  require Logger

  @derive {Jason.Encoder, only: [:text, :image_url, :id]}
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "projects" do
    field :text, :string, default: "Item"
    field :image_url, :string, default: ""
  end

  def changeset(%__MODULE__{} = module, attrs) do
    module
    |> cast(attrs, [
      :id,
      :image_url,
      :text
    ])
    |> autogenerate_id_if_not_exists()
    |> validate_length(:image_url, max: 300)
    |> validate_length(:text, max: 256)
  end
end
