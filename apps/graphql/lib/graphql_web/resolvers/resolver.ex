defmodule Graphql.Resolver do
  def addresses(args, _info) do
    # Check out the DB module to see the functions you can use
    # to interact with the database.
  end

  def smoke_test(_args, _info) do
    {:ok, "Yes!"}
  end

  def test_update(%{input: input}, _info) do
    {:ok, input}
  end
end
