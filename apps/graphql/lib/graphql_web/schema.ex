defmodule Graphql.Schema do
  use Absinthe.Schema

  query do
    field(:hello, type: :string, resolve: fn _, _, _ -> {:ok, "It's alive"} end)
  end
end
