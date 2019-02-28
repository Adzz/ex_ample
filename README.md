# ExAmple

## My second Query - Answers

#### schema.ex

Our land reg data type should be defined as follows:
```elixir
  object :land_reg_data do
    field(:address_id, :id)
    field(:average_time_to_sold, :integer)
  end
```

We implemented the resolver like this, inside the query:
```elixir
    field :land_reg_data, type: list_of(:land_reg_data) do
      arg(:address_id, non_null(:id))
      resolve(&Graphql.Resolver.land_reg_data/2)
    end
```

#### resolver.ex

Using the handy built in functions, we fetch the data like so:
```elixir
  def land_reg_data(args, _info) do
    DB.get(LandRegData, address_id: args.address_id)
  end
```

## My first Mutation

Superb work! We can now query the land reg for data. But what if someone has a house that we haven't heard of yet? We want people to be able to create an address, then query the land reg for that address. For that we need a mutation.

You know how it goes, run the test, watch the one in `apps/graphql/test/integration/my_first_mutation_test.exs` fail, then, you know, make it pass!
