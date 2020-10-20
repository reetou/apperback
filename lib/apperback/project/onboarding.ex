defmodule Apperback.Project.Onboarding do
  alias Apperback.Project.OnboardingItem
  use Ecto.Schema
  use MakeEnumerable
  import Apperback.Helpers
  import Ecto.Changeset
  require Logger

  @derive Jason.Encoder
  @primary_key {:id, :binary_id, autogenerate: true}
  embedded_schema do
    field :background_color, :string, default: "#FFFFFF"
    field :text_color, :string, default: "#000000"
    field :next_page_id
    embeds_many :items, OnboardingItem
  end

  def changeset(%__MODULE__{} = module, attrs) do
    module
    |> cast(attrs, [
      :id,
      :background_color,
      :text_color,
      :next_page_id
    ])
    |> autogenerate_id_if_not_exists()
    |> cast_embed(:items)
    |> validate_length(:background_color, max: 30)
    |> validate_length(:text_color, max: 30)
    |> validate_length(:next_page_id, max: 256)
    |> validate_length(:items, max: 4)
  end
end
