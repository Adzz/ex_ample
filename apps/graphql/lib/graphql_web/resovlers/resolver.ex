defmodule Graphql.Resolver do
  def addresses(_args, _info) do
    # Do your best here:
  end

  def smoke_test(_args, _info) do
    {:ok, "Yes!"}
  end

  def test_update(%{input: input}, _info) do
    {:ok, input}
  end
end
