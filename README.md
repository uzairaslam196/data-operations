# DataOperations

DataOperations is an Elixir project that provides APIs and functionalities for working with restaurant data. It allows you to perform various operations and retrieve information related to restaurants and their customers.

## Information
1. Used `credo` and `dialyzer` deps for code quality.
2. Used `money` deps to work with money related information.
3. Added docs and type specs with each method in `restaurants` context.
4. Path for restaurants context `lib/data_operations/restaurants.ex`
5. Path for test cases `test/data_operations/restaurants_test.exs`
6. Wrote test cases for all questions.
7. Also documented all questions in read me.
8. Documented resutaurants context in read me. 
8. Keep auto format by setting in .vscode

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

Returns a list of information about popular dishes in each restaurant. The most popular dish is the one that is served to customers the most times.

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

Returns a list of information about profitable dishes in each restaurant. The most profitable dish is the one that made maximum money.

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

## Questions
1. How many customers visited the "Restaurant at the end of the universe"?
  ```
  iex> DataOperations.Restaurants.visited_customers_count("the-restaurant-at-the-end-of-the-universe")
  37230
  ```
  
2. How much money did the "Restaurant at the end of the universe" make?
  ```
  iex> DataOperations.Restaurants.total_money_made("the-restaurant-at-the-end-of-the-universe")
  %Money{amount: 18694400, currency: :USD} or 18694400/100 = 18694.40
  ```

3. What was the most popular dish at each restaurant?

concise_name: It's restaurant name

food: It's a dish name

food_count: Number of time served.

  ```
  iex> DataOperations.Restaurants.popular_dishes_in_resturants()
  [
    %{concise_name: "bean-juice-stand", food: "honey", food_count: 1185},
    %{concise_name: "johnnys-cashew-stand", food: "juice", food_count: 1196},
    %{concise_name: "the-ice-cream-parlor", food: "beans", food_count: 1151},
    %{
      concise_name: "the-restaurant-at-the-end-of-the-universe",
      food: "cheese",
      food_count: 1158
    }
  ]
  ```

4. What was the most profitable dish at each restaurant?

  Here is contradiction, most profitable dish could be that which get served maximum times, any dish which is sell most gives more profit. But it could be also that dish which made maximum money. I would like to discuss it with team in reality. However for now I selected second option.

  concise_name: It's restaurant name

  food: It's a dish name

  food_cost: Total money made by dish.

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
    %{
      concise_name: "the-ice-cream-parlor",
      food: "coffee",
      food_cost: %Money{amount: 578950, currency: :USD}
    },
    %{
      concise_name: "the-restaurant-at-the-end-of-the-universe",
      food: "cheese",
      food_cost: %Money{amount: 586150, currency: :USD}
    }
  ]
  ```

5. Who visited each store the most, and who visited the most stores?

  ```
  iex> DataOperations.Restaurants.most_visit_information()
  %{
    customer_visited_most_stores: %{store_count: 3462, visitor: "Michael"},
    most_visited_resturant: %{store: "johnnys-cashew-stand", visitor_count: 37909}
  }
  ```

6. How would you build this differently if the data was being streamed from Kafka?

  I'm don't have professional experience with Kafka yet, but if we use it instead of a CSV file, we'll need to build a Kafka container that can process a stream of messages and then integrate the data into a database. Once the data is in the database, we can write APIs to get information about restaurants. 
  However, if data is not obtained from the database, we can send a message to a Kafka topic to obtain the desired data and then store it in the database.
  As a result, we will create a method similar to get_or_store.

7. How would you improve the deployment of this system?

  Using continuous integration and deployment (CI/CD), we can improve the deployment system. For CI, we can use github actions. If all test cases and quality checks pass in the CI pipeline, the deployment step is automatically moved. As a result, we will have an automated system that will run on each new PR.

