defmodule Graphql.Resolver do
<<<<<<< HEAD
  def addresses(_args, _info) do
=======
  def land_reg_data(args, _info) do
>>>>>>> Adds failing test for first query
    # Do your best here:
  end

  def smoke_test(_args, _info) do
    {:ok, "Yes!"}
  end

  def test_update(%{input: input}, _info) do
    {:ok, input}
  end
end
