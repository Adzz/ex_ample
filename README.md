# ExAmple

This repo is designed to help you get familiar with building graphql APIs using elixir. The idea is to step through the branches completing the exercises outlined in the readme as you go. Step through the branches in this order:

```
master
add-phoenix
my-first-query
my-second-query
my-first-mutation
my-first-resolving-function
```

## Umbrella projects - Coding in the Rain

[Umbrella projects](https://8thlight.com/blog/georgina-mcfadyen/2017/05/01/elixir-umbrella-projects.html) are a great way to manage internal dependancies for your applications. Internal dependencies can be thought of as libraries that can sit on their own - but that you don't want to or cannot open source. They are things that you can configure their own relases for (so can be released independently from the rest of the application), but are conveniently grouped together into one git repo.

If you have ever had one repo rely on another, you'll soon find these lifesavers; no more using git tags and bumping versions in your mix files so you can get new features!

However, apps within an umbrella projects are not _completely_ decoupled. From [the docs](https://elixir-lang.org/getting-started/mix-otp/dependencies-and-umbrella-projects.html#dont-drink-the-kool-aid)

> While it provides a degree of separation between applications, those applications are not fully decoupled, as they are assumed to share the same configuration and the same dependencies.

And

> If you find yourself in a position where you want to use different configurations in each application for the same dependency or use different dependency versions, then it is likely your codebase has grown beyond what umbrellas can provide.

Today we will be looking at a small example of how you might structure an umbrella project. The project will be a graphql API connected to a data source, which we will query from a react app. Our job will be to develop this API such that we can query the data source, manipulate some data before we expose it to the client and mutate some data and save it successfully.

## Getting Started - How did we get here?


So far to create this repo, we first ran this task:

```sh
mix new ex_ample --umbrella
```

The name of the app is `ex_ample`, and the umbrella flag does exactly what you think it does.


### Adding to the umbrella


To add new apps to the umbrella project we can do this (from the root of the project):

```sh
cd apps && mix new name_of_the_app --sup
```

The `sup` flag stands for supervision, it just tells Mix to generate a supervision tree automatically for us, instead of having to build one manually. More in [the docs 👩‍⚕️](https://elixir-lang.org/getting-started/mix-otp/dependencies-and-umbrella-projects.html#dont-drink-the-kool-aid)


We have already added an app called `ex_ample_backend`. This will act as the datasource for our application. It has VERY limited capabilities. I don't recommend that you read the code unless you have a penchant for punishment. I certainly don't recomend you use it past this exercise.

### Adding a graphql layer

We want to:

  1. Add a new app to the umbrella project. Call it what you like, but it will act as the webserver layer for this project. It should be a phoenix app, but we don't need ecto, html, or brunch!
  2. Add the following deps to it:
    - [Absinthe](https://github.com/absinthe-graphql/absinthe)
    - [Jason](https://github.com/michalmuskala/jason)
    - [Absinthe Plug](https://github.com/absinthe-graphql/absinthe_plug)
  3. Alter the plug for parsing JSON to use the Jason lib (the default is Poison)
  4. Add a route for graphql requests
  5. Add a route for [graphiql](https://github.com/graphql/graphiql) requests (they are different things!), but only for dev
  6. Make a successful `hello` request using graphiql

But do not fear, we will step through this together!

### The Answers

1. To complete the mission, we had to [read this](https://hexdocs.pm/phoenix/up_and_running.html) then do this:

```sh
mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez
cd apps
mix phx.new graphql --no-ecto --no-brunch --no-html
```

2. Then we needed to add the deps so that our `deps` function in the `mix.exs` file looks like this:

```elixir
  defp deps do
    [
      {:phoenix, "~> 1.3.3"},
      {:phoenix_pubsub, "~> 1.0"},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      # these are the deps we added:
      {:absinthe, "~> 1.4.0"},
      {:absinthe_plug, "~> 1.4.0"},
      {:jason, "~> 1.1"}
    ]
  end
```

3. Altering the plug to use the Jason lib, looked something like this (inside of `apps/graphql/lib/graphql_web/endpoint.ex`):

```elixir
  plug(
    Plug.Parsers,
    parsers: [:json],
    pass: ["*/*"],
    json_decoder: Jason,
    schema: Graphql.Schema
  )
```

4 and 5. The router file `apps/graphql/lib/graphql_web/router.ex` should now look like this:

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

And finally for 6 we added a schema file here `apps/graphql/lib/graphql_web/schema.ex` that looks like this:

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
    {:ok, "Yes!"}
  end

  def test_update(%{input: input}, _info) do
    {:ok, input}
  end
end
```

This resolver pattern is great groundwork for the architecture of the application as it grows, even if it is overkill right now.
