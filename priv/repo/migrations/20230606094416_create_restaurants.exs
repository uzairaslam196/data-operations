defmodule DataOperations.Repo.Migrations.CreateResturants do
  use Ecto.Migration

  @csv_file "priv/repo/csv/restaurants_data.csv"
  def change do
    create table(:restaurants) do
      add :concise_name, :string, null: false
      add :food, :string, null: false
      add :customer_name, :string, null: false
      add :food_cost, :integer

      timestamps()
    end

    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    @csv_file
    |> File.stream!()
    |> Stream.drop(1)
    |> CSV.decode!()
    |> Enum.each(fn [concise_name, food, customer_name, food_cost] ->
      execute("""
      INSERT INTO restaurants (concise_name, food, customer_name, food_cost, inserted_at, updated_at)
      VALUES
      ('#{concise_name}', '#{food}', '#{customer_name}', '#{round(String.to_float(food_cost) * 100)}', '#{now}', '#{now}')
      """)
    end)
  end
end
