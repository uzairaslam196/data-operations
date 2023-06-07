defmodule DataOperations.RestaurantsTest do
  use DataOperations.DataCase

  alias DataOperations.Restaurants

  test "customers visited the resturant 'the-restaurant-at-the-end-of-the-universe'" do
    resturant = "the-restaurant-at-the-end-of-the-universe"
    assert 37230 == Restaurants.visited_customers_count(resturant)
  end

  test "customers visited the resturant that doesnot-exist" do
    resturant = "doesnot-exist"
    assert 0 == Restaurants.visited_customers_count(resturant)
  end

  test "money make by resturant 'the-restaurant-at-the-end-of-the-universe'" do
    resturant = "the-restaurant-at-the-end-of-the-universe"

    assert %Money{amount: amount, currency: :USD} = Restaurants.total_money_made(resturant)
    assert 18_694_400 == amount
    assert 18_694_4 == amount / 100
  end

  test "money make by resturant that doesnot-exist" do
    resturant = "doesnot-exist"

    refute Restaurants.total_money_made(resturant)
  end

  @resturant_1 "bean-juice-stand"
  @resturant_2 "johnnys-cashew-stand"
  @resturant_3 "the-ice-cream-parlor"
  @resturant_4 "the-restaurant-at-the-end-of-the-universe"

  test "popular dish at each resturant" do
    assert resturants_with_popular_dishes = Restaurants.popular_dishes_in_resturants()

    assert 4 == Enum.count(resturants_with_popular_dishes)

    # for @resturant_1
    resturants_with_popular_dish = get_resturant(resturants_with_popular_dishes, @resturant_1)
    popular_dish = "honey"
    times_served = 1185
    assert %{food: ^popular_dish, food_count: ^times_served} = resturants_with_popular_dish

    # for @resturant_2
    resturants_with_popular_dish = get_resturant(resturants_with_popular_dishes, @resturant_2)
    popular_dish = "juice"
    times_served = 1196
    assert %{food: ^popular_dish, food_count: ^times_served} = resturants_with_popular_dish

    # for @resturant_3
    resturants_with_popular_dish = get_resturant(resturants_with_popular_dishes, @resturant_3)
    popular_dish = "beans"
    times_served = 1151
    assert %{food: ^popular_dish, food_count: ^times_served} = resturants_with_popular_dish

    # for @resturant_4
    resturants_with_popular_dish = get_resturant(resturants_with_popular_dishes, @resturant_4)
    popular_dish = "cheese"
    times_served = 1158
    assert %{food: ^popular_dish, food_count: ^times_served} = resturants_with_popular_dish
  end

  test "profitable dish at each resturant" do
    assert resturants_with_profitable_dishes = Restaurants.profitable_dishes_in_resturants()

    assert 4 == Enum.count(resturants_with_profitable_dishes)

    # for @resturant_1
    resturant_with_profit_dish = get_resturant(resturants_with_profitable_dishes, @resturant_1)
    profitable_dish = "honey"
    food_cost = %Money{amount: 594_550, currency: :USD}
    assert %{food: ^profitable_dish, food_cost: ^food_cost} = resturant_with_profit_dish

    # for @resturant_2
    resturant_with_profit_dish = get_resturant(resturants_with_profitable_dishes, @resturant_2)
    profitable_dish = "juice"
    food_cost = %Money{amount: 598_900, currency: :USD}
    assert %{food: ^profitable_dish, food_cost: ^food_cost} = resturant_with_profit_dish

    # for @resturant_3
    resturant_with_profit_dish = get_resturant(resturants_with_profitable_dishes, @resturant_3)
    profitable_dish = "coffee"
    food_cost = %Money{amount: 578_950, currency: :USD}
    assert %{food: ^profitable_dish, food_cost: ^food_cost} = resturant_with_profit_dish

    # for @resturant_4
    resturant_with_profit_dish = get_resturant(resturants_with_profitable_dishes, @resturant_4)
    profitable_dish = "cheese"
    food_cost = %Money{amount: 586_150, currency: :USD}
    assert %{food: ^profitable_dish, food_cost: ^food_cost} = resturant_with_profit_dish
  end

  test "sotre with most visits, and customer who visited most stores" do
    assert %{
             customer_visited_most_stores: customer_visited_most_stores,
             most_visited_resturant: most_visited_resturant
           } = Restaurants.most_visit_information()

    assert %{store_count: total_stores_visited, visitor: visitor} = customer_visited_most_stores
    assert "Michael" == visitor
    assert 3462 == total_stores_visited

    assert %{visitor_count: total_visitors, store: store} = most_visited_resturant
    assert "johnnys-cashew-stand" == store
    assert 37909 == total_visitors
  end

  defp get_resturant(resturants, resturant_name) do
    Enum.find(resturants, &(&1.concise_name == resturant_name))
  end
end
