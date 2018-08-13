defmodule Graphql.Resolver do
  def addresses(_args, _info) do
    DB.all(Address)
  end

  def land_reg_data(args, _info) do
    # We probably need to head to the DB...
  end

  def smoke_test(_args, _info) do
    {:ok, "Yes!"}
  end

  def test_update(%{input: input}, _info) do
    {:ok, input}
  end
end
