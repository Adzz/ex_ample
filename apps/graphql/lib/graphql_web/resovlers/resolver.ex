defmodule Graphql.Resolver do
  def addresses(_args, _info) do
<<<<<<< HEAD
    # Do your best here:
=======
    DB.all(Address)
>>>>>>> implements my first query
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
