# ExAmple

This repo is designed to help you get familiar with building graphql APIs using elixir. The idea is to step through the branches completing the exercises outlined in the readme as you go. Step through the branches in this order:

```
master
my-first-query
my-second-query
my-first-mutation
my-first-resolving-function
```

## Umbrella projects - Coding in the Rain

[Umbrella projects](https://8thlight.com/blog/georgina-mcfadyen/2017/05/01/elixir-umbrella-projects.html) are a great way to manage internal dependencies for your applications. Internal dependencies can be thought of as libraries that can sit on their own - but that you don't want to or cannot open source. They are things that you can configure their own releases for (so can be released independently from the rest of the application), but are conveniently grouped together into one git repo.

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

The `sup` flag stands for supervision, it just tells Mix to generate a supervision tree automatically for us, instead of having to build one manually. More in [the docs 👩‍⚕️](https://elixir-lang.org/getting-started/mix-otp/dependencies-and-umbrella-projects.html#umbrella-projects)

We have already added an app called `ex_ample_backend`. This will act as the datasource for our application. It has VERY limited capabilities. I don't recommend that you read the code unless you have a penchant for punishment. I certainly don't recomend you use it past this exercise.

### Adding a phoenix app

For creating a phoenix app in your umbrella, make sure you're in the `apps` directory and run:

```sh
mix phx.new name_of_app --no-ecto --no-html
```

`--no-ecto` and `--no-html` flags are optional. The `--no-ecto` flag means Ecto files are not generated and the `--no-html` means no HTML views are generated (Ecto is a database wrapper for Elixir and as this example has no database, we don't need it.)

<details>
<summary>Wait, what is Phoenix?</summary>
<br>
Phoenix is a web development framework written in Elixir which implements the server-side Model View Controller (MVC) pattern. Check out the docs here: https://hexdocs.pm/phoenix/overview.html#content. Phoenix is the top layer of a multi-layer system designed to be modular and flexible. The other layers include Cowboy, Plug and Ecto.
</details>

### Getting started: adding a graphql layer

Follow these steps to setup your elixir graphql project. Open up a hint if you get stuck!

#### Step 1. 
Add a new app to the umbrella project. Call it what you like, but it will act as the webserver layer for this project. It should be a phoenix app and we don't need ecto or html.

#### Step 2. 
Add the following deps to your new app:

- [Absinthe](https://github.com/absinthe-graphql/absinthe)
- [Absinthe Plug](https://github.com/absinthe-graphql/absinthe_plug)

<details>
<summary>What is Absinthe? Why are we adding it?</summary>
<br>
Absinthe is the GraphQL toolkit for Elixir, built to suit Elixir's capabilities and style. With Absinthe, you define the schema and resolution functions and it executes GraphQL documents.

On client side Absinthe has support for Relay and Apollo client and in Elixir it uses Plug and Phoenix to support HTTP APIs, via `absinthe_plug` and `absinthe_phoenix` packages. It also has support for Ecto via the `absinthe_ecto package`.
</details>

#### Step 3. 
Find your newly-created `router.ex` file and add a route for graphql requests (`/graphql`)

<details>
<summary>Hint:</summary>
<br>
You're going to pass the incoming requests straight to Absinthe Plug (which does all the hard work for you). You might find the [`forward`](https://hexdocs.pm/phoenix/Phoenix.Router.html#forward/4) function useful...  
</details>

#### Step 4. 
Add a route for [graphiql](https://github.com/graphql/graphiql) requests (this is different to graphql!), but only expose it in dev

<details>
<summary>Hint:</summary>
<br>
You're in dev if `Mix.env() == :dev` evaluates to true...
</details>

#### Step 5. 
Add a `schema.ex` file and add a resolvers folder with a `resolver.ex` file in it (put these at the same level as your router). Write a 'Hello world' smoke test by adding a simple query in the schema and a resolver function that returns `{:ok, "Hello World"}`

When you finish this, pat yourself on the back - you just setup GraphQL in Elixir! To carry on with the tutorial checkout the next branch: `my-first-query` (it has the answers to this stage, but don't tell anyone).
