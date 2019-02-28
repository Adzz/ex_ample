# ExAmple

### The Answers

1. To complete the mission, we [read some docs](https://hexdocs.pm/phoenix/up_and_running.html) and did this:

```sh
cd apps
mix phx.new graphql --no-ecto --no-html
```

2. Then we needed to add the deps so that our `deps` function in the `mix.exs` file looks like this:

```elixir
  defp deps do
    [
      {:phoenix, "~> 1.4.0"},
      {:phoenix_pubsub, "~> 1.1"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"}
      # these are the deps we added:
      {:absinthe, "~> 1.4.0"},
      {:absinthe_plug, "~> 1.4.0"},
    ]
  end
```

3 and 4s. The router file `apps/graphql/lib/graphql_web/router.ex` should now look like this:

```elixir
  scope "/graphql" do
    forward(
      "/",
      Absinthe.Plug,
      schema: Graphql.Schema,
      json_codec: Jason
    )
  end

  if Mix.env() == :dev do
    forward(
      "/graphiql",
      Absinthe.Plug.GraphiQL,
      schema: Graphql.Schema,
      json_codec: Jason,
      default_url: "/graphiql",
      interface: :advanced
    )
  end
```

And finally for 5 we added a schema file here `apps/graphql/lib/graphql_web/schema.ex` that looks like this (don't worry that you didn't add the mutation, have a look at how it compares):

```elixir
defmodule Graphql.Schema do
  use Absinthe.Schema

  query do
    field :is_this_thing_on, type: :string do
      resolve(&Graphql.Resolver.smoke_test/2)
    end
  end

  mutation do
    field :echo_text, type: :string do
      arg(:input, :string)
      resolve(&Graphql.Resolver.test_update/2)
    end
  end
end
```

We then added a resolver file here: `apps/graphql/lib/graphql_web/resolvers/resolver.ex` which looked like this:

```elixir
defmodule Graphql.Resolver do
  def smoke_test(_args, _info) do
    {:ok, "Hello world!"}
  end

  def test_update(%{input: input}, _info) do
    {:ok, input}
  end
end
```

This resolver pattern is great groundwork for the architecture of the application as it grows, even if it is overkill right now.

## My first query

Now that we have successfully wired up our new app, we need to be able to query for some data.

Our next challenge will be to implement a new query which will get some data from our database, and expose it in our API. Along the way we will learn how Absinthe looks at things, and what we can do about it.

We will implement a query for all of the addresses we have in our DB, we will know we have successfully implemented the feature when all the tests are green.

To get started head to the tests in `apps/graphql/test/integration/my_first_query_test.exs` run them with `mix test` to see them fail. Then head to `apps/graphql/lib/graphql_web/schema.ex` for hints on how to get going.

When it passes try booting the server with `mix phx.server` then head to `localhost:4000/graphiql` and try running the query using graphiql.

When you're done, checkout `my-second-query` for more querying fun!
