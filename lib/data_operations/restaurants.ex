defmodule DataOperations.Restaurants do
  @moduledoc """
  Provides context for resturants
  """

  alias DataOperations.{Repo, Restaurant}
  import Ecto.Query, only: [from: 2]

  @doc """
  Returns the total count of visited customers for any resturant.
  Note: Anyone who visits the same restaurant more than once will be counted as multiple customers.

  ## Examples

    iex> visited_customers_count("the-ice-cream-parlor")
    37230

    iex> visited_customers_count("not-exist")
    0
  """

  @spec visited_customers_count(String.t()) :: non_neg_integer()
  def visited_customers_count(concise_name) when is_binary(concise_name) do
    from(r in Restaurant,
      where: r.concise_name == ^concise_name,
      select: count(r)
    )
    |> Repo.one()
  end

  @doc """
  Returns the total money made by any resturant

  ## Examples

    iex> total_money_made("the-ice-cream-parlor")
    %Money{amount: 18632800, currency: :USD}

    iex> visited_customers_count("not-exist")
    nil
  """

  @spec total_money_made(String.t()) :: Money.t() | nil
  def total_money_made(concise_name) when is_binary(concise_name) do
    from(r in Restaurant,
      where: r.concise_name == ^concise_name,
      select: sum(r.food_cost)
    )
    |> Repo.one()
  end

  @doc """
  Returns map with most_visited_restaurant and customer_visited_most_stores.

  ## Examples

    iex> most_visit_information()
    %{
      customer_visited_most_stores: %{store_count: 3462, visitor: "Michael"},
      most_visited_resturant: %{store: "johnnys-cashew-stand", visitor_count: 37909}
    }
  """

  @spec most_visit_information :: %{
          customer_visited_most_stores: non_neg_integer(),
          most_visited_resturant: non_neg_integer()
        }
  def most_visit_information() do
    most_visited_resturant =
      from(r in Restaurant,
        group_by: r.concise_name,
        select: %{store: r.concise_name, visitor_count: count(r.customer_name)},
        order_by: [desc: count(r.customer_name)],
        limit: 1
      )
      |> Repo.one()

    customer_visited_most_stores =
      from(r in Restaurant,
        group_by: r.customer_name,
        select: %{visitor: r.customer_name, store_count: count(r.concise_name)},
        order_by: [desc: count(r.concise_name)],
        limit: 1
      )
      |> Repo.one()

    %{
      most_visited_resturant: most_visited_resturant,
      customer_visited_most_stores: customer_visited_most_stores
    }
  end

  @doc """
  Returns information about the most popular dishes at each restaurant. The most popular dish is
  the one that is served to customers the most times.

  concise_name: It's a resturant name
  food: it's a dish name
  food_count: Number of times served

  ## Examples

    iex> popular_dishes_in_resturants()
    [
      %{concise_name: "bean-juice-stand", food: "honey", food_count: 1185},
      %{concise_name: "johnnys-cashew-stand", food: "juice", food_count: 1196} | _
    ]
  """

  @spec popular_dishes_in_resturants() :: list(popular_dish())
  @type popular_dish() :: %{
          concise_name: String.t(),
          food: String.t(),
          food_count: non_neg_integer
        }
  def popular_dishes_in_resturants() do
    query = """
      WITH max_counts AS (
        SELECT r.concise_name, r.food, count(r.food) AS food_count
        FROM restaurants AS r
        GROUP BY r.concise_name, r.food
        ),
        max_foods AS (
        SELECT mc.concise_name, mc.food, mc.food_count,
          row_number() OVER (PARTITION BY mc.concise_name ORDER BY mc.food_count DESC) AS rn
        FROM max_counts AS mc
        )
      SELECT mf.concise_name, mf.food, mf.food_count
      FROM max_foods AS mf
      WHERE mf.rn = 1
    """

    query |> Repo.query([]) |> to_map()
  end

  @doc """
  Returns a list of profitable dishes for each restaurant. The most profitable dish is the one
  that made maximum money.

  concise_name: It's resturant name
  food: it's dish name
  food_cost: Total money made

  ## Examples

    iex> profitable_dishes_in_resturants()
    [
      %{
        concise_name: "bean-juice-stand",
        food: "honey",
        food_cost: %Money{amount: 594550, currency: :USD}
      },
      %{
        concise_name: "johnnys-cashew-stand",
        food: "juice",
        food_cost: %Money{amount: 598900, currency: :USD}
      } | _
    ]
  """

  @spec profitable_dishes_in_resturants() :: list(profitable_dish())
  @type profitable_dish() :: %{
          concise_name: String.t(),
          food: String.t(),
          food_cost: Money.t()
        }
  def profitable_dishes_in_resturants() do
    query = """
      WITH max_counts AS (
        SELECT r.concise_name, r.food, sum(r.food_cost) AS food_cost
        FROM restaurants AS r
        GROUP BY r.concise_name, r.food
        ),
        max_foods AS (
        SELECT mc.concise_name, mc.food, mc.food_cost,
          row_number() OVER (PARTITION BY mc.concise_name ORDER BY mc.food_cost DESC) AS rn
        FROM max_counts AS mc
        )
      SELECT mf.concise_name, mf.food, mf.food_cost
      FROM max_foods AS mf
      WHERE mf.rn = 1
    """

    query |> Repo.query([]) |> to_map() |> Enum.map(&%{&1 | food_cost: Money.new(&1.food_cost)})
  end

  defp to_map({:ok, %Postgrex.Result{columns: columns, rows: rows}}) do
    columns = Enum.map(columns, &String.to_atom(&1))

    for row <- rows, do: Enum.zip_reduce(columns, row, %{}, &Map.put(&3, &1, &2))
  end
end
