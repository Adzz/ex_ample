defmodule Graphql.Resolver do
  def addresses(_args, _info) do
    DB.all(Address)
  end

  # what new function shalle we put here?

  def smoke_test(_args, _info) do
    {:ok, "Yes!"}
  end

  def test_update(%{input: input}, _info) do
    {:ok, input}
  end
end
