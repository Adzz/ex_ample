defmodule GraphqlWeb.Router do
  use GraphqlWeb, :router

  get("/", Graphql.PageController, :index)

  scope "/api" do
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
end
