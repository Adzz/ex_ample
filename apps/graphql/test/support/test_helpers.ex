defmodule Graphql.TestHelpers do
  @doc """
  Allows us to make a graphql query to /api with variables if needed. Is a macro so that we have
  access to the post function where it is used (i.e. in the test).
  """
  # The Macro.expand is needed because quote / unquote works on AST and an empty map is not that
  # see here for more: https://elixirforum.com/t/cant-seem-to-unquote-a-map/4009/2
  defmacro make_graphql_query(context, query, variables \\ Macro.escape(%{})) do
    quote do
      unquote(context)
      |> post("/api", %{
        "query" => unquote(query),
        "variables" => unquote(variables)
      })
      |> json_response(unquote(200))
    end
  end

  @doc """
  Allows us to make a graphql mutation to /api with variables if needed. Is a macro so that we have
  access to the post function where it is used (i.e. in the test).
  """
  # The Macro.expand is needed because quote / unquote works on AST and an empty map is not that
  # see here for more: https://elixirforum.com/t/cant-seem-to-unquote-a-map/4009/2
  defmacro make_graphql_mutation(context, mutation, variables \\ Macro.escape(%{})) do
    quote do
      unquote(context)
      |> post("/api", %{
        "query" => unquote(mutation),
        "variables" => unquote(variables)
      })
      |> json_response(unquote(200))
    end
  end
end
