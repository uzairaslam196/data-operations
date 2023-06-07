defmodule DataOperations.Restaurant do
  @moduledoc false
  use Ecto.Schema

  schema "restaurants" do
    field :food, :string
    field :food_cost, Money.Ecto.Amount.Type
    field :concise_name, :string
    field :customer_name, :string

    timestamps()
  end
end
