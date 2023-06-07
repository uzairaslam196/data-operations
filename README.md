# DataOperations

DataOperations is an Elixir project that provides APIs and functionalities for working with restaurant data. It allows you to perform various operations and retrieve information related to restaurants and their customers.

## Information
1. Used `credo` and `dialyzer` deps for code quality.
2. Used `money` deps to work with money related information.
3. Added docs and type specs with each method in `restaurants` context.
4. Path for restaurants context `lib/data_operations/restaurants.ex`
5. Path for test cases `test/data_operations/restaurants_test.exs`
6. Keep auto format by setting in .vscode

## Setup

To set up the project, follow these steps:

1. Clone the repository:

```
git clone git@github.com:uzairaslam196/data-operations.git
```

2. Install dependencies:
  ```
  cd DataOperations
  mix deps.get
  ```

3. Set up the database:

```
mix ecto.reset
```

This will create and migrate the database, as well as seed it with sample restaurant data.

## Running Tests

To run the test cases, use the following command:

```
mix test
```

This will execute all the test cases defined in the `test/data_operations/restaurant_text.exs` file.

## Restaurant Context

The **DataOperations.Restaurants** module provides a context for working with restaurants. It offers the following functions:


You can start application using this command

```
iex -S mix
```

Then you can call these methods in shell to check their results manually.

**visited_customers_count/1**

Returns the total count of visited customers for a given restaurant.

```
iex> DataOperations.Restaurants.visited_customers_count("the-ice-cream-parlor")
37230

iex> DataOperations.Restaurants.visited_customers_count("not-exist")
0
```

**total_money_made/1**

Returns the total money made by a given restaurant.

```
iex> DataOperations.Restaurants.total_money_made("the-ice-cream-parlor")
%Money{amount: 18632800, currency: :USD}

iex> DataOperations.Restaurants.total_money_made("not-exist")
nil
```

**most_visit_information/0**

Returns a map with information about the most visited restaurant and the customer who visited the most stores.

```
iex> DataOperations.Restaurants.most_visit_information()
%{
  customer_visited_most_stores: %{store_count: 3462, visitor: "Michael"},
  most_visited_resturant: %{store: "johnnys-cashew-stand", visitor_count: 37909}
}
```

**popular_dishes_in_resturants/0**

Returns a list of information about popular dishes in each restaurant.

concise_name: It's a restaurant name

food: It's a popular dish

food_count: Number of times served dish

```
iex> DataOperations.Restaurants.popular_dishes_in_resturants()
[
  %{concise_name: "bean-juice-stand", food: "honey", food_count: 1185},
  %{concise_name: "johnnys-cashew-stand", food: "juice", food_count: 1196},
  ...
]
```

**profitable_dishes_in_resturants/0**

Returns a list of information about profitable dishes in each restaurant.

concise_name: It's a restaurant name

food: It's a profitable dish

food_cost: Total money made by dish

```
iex> DataOperations.Restaurants.profitable_dishes_in_resturants()
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
  },
  ...
]
```

Please refer to the module documentation for more details on the function usage and examples.

