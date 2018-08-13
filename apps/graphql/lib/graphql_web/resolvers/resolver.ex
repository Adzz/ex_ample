defmodule Graphql.Resolver do
  def addresses(_args, _info) do
    DB.all(Address)
  end

  def land_reg_data(args, _info) do
    DB.get(LandRegData, address_id: args.address_id)
  end

  def create_address(args, _info) do
    # Ensure we persist it!
  end

  def smoke_test(_args, _info) do
    {:ok, "Yes!"}
  end

  def test_update(%{input: input}, _info) do
    {:ok, input}
  end
end
