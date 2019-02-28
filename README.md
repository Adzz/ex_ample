# ExAmple

## My first Mutation - Answers

#### schema.ex

Here we go again. We made an input object like so:
```elixir
  input_object :address_input do
    field(:postcode, :string)
    field(:house_number, :integer)
  end
```

And we added a field into the mutation:
```elixir
    field :create_address, type: :address do
      arg(:input, :address_input)
      resolve(&Graphql.Resolver.create_address/2)
    end
```

Finally we used the `create` helper to add to the database. Notice the pattern matching in the arguments to make this nice and tidy.
```elixir
  def create_address(%{input: input}, _info) do
    DB.create(Address, postcode: input.postcode, house_number: input.house_number)
  end
```

## My first resolving function

Okay, so technically it isn't your first resolving function. We have been using resolver functions when we wrote things in our schema like:

```elixir
resolve(&Graphql.Resolver.addresses/2)
```

The clue was in the name. However, this time we are going to take resolving functions one step futher - to the graphql types that we are returning.

The scenario is this, we want to be able to return a formatted address for a given property. To do this, we need to get the postcode and house number from the address and return it formatted nicely in a string. We then want to expose that string as a field on the address type, called `formatted_address`

We have written a test (`apps/graphql/test/integration/my_first_resolving_function_test.exs`), work your magic to bring green to the land.
