# ExAmple


[Umbrella projects](https://8thlight.com/blog/georgina-mcfadyen/2017/05/01/elixir-umbrella-projects.html) are a great way to manage internal dependancies for your applications. Internal dependencies can be thought of as libraries that can sit on their own - but that you don't want to or can't open source. They are things that you can configure their own relases for (so can be released independently from the rest of the application), but are conveniently grouped together in one git repo.

If you have ever had one repo rely on another, you'll soon find these lifesavers; no more using git tags and bumping versions in your mix files so you can get new features.


So far to create this repo, all we have done is run this task:

```sh
mix new ex_ample --umbrella
```

The name of the app is ex_ample, and the umbrella flag does exactly what you think it does.


To add new apps to the umbrella project we can do this:

```sh

```

