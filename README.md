# ExAmple

## My first query - Answers

To make our first query and pass the test, we had to update our `schema.ex`. We added to the object that describes the address data we were expecting back:

```elixir
  object :address do
    field(:id, non_null(:id))
    field(:postcode, :string)
    field(:house_number, :integer)
  end
```

Then we added our resolver function to the `get_addresses` query field:

```elixir
  field :get_addresses, type: list_of(:address) do
    resolve(&Graphql.Resolver.addresses/2)
  end
```

To actually pull those addresses, we needed to write an implementation for the resolver:

```elixir
  def addresses(_args, _info) do
    DB.all(Address)
  end
```

## My second Query

Excellent! Now we have addresses, we can take the id of one of those addresses and implement a query that will allow us to find land reg data for it, specifically the average time to sold for a property.

Again we have a failing test in `apps/graphql/test/integration/my_second_query_test.exs` and some hints on what to do in `schema.ex`.

This time our query will need some args...

When it passes try booting the server with `mix phx.server` then head to `localhost:4000/graphiql` and try running the query using graphiql.

When you're done, move on to `my-first-mutation`
