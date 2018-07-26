# ExAmple

### Umbrella projects - Coding in the Rain

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
$mix new ex_ample --umbrella
```

The name of the app is `ex_ample`, and the umbrella flag does exactly what you think it does.


### Adding to the umbrella


To add new apps to the umbrella project we can do this (from the root of the project):

```sh
$cd apps && mix new ex_ample_backend --sup
```

The `sup` flag stands for supervision, it just tells Mix to generate a supervision tree automatically for us, instead of having to build one manually. More in [the docs](https://elixir-lang.org/getting-started/mix-otp/dependencies-and-umbrella-projects.html#dont-drink-the-kool-aid) 👩‍⚕️


This generated a scaffold of the code you can see in `apps/ex_ample_backend`. We have implemented a VERY simple database, faff with setting up postgres. I don't recommend that you read it, unless you have a penchant for punishment. I certainly don't recomend you use it past this exercise.



