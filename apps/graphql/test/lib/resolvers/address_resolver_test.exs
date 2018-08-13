defmodule AddressResolverTest do
  use ExUnit.Case

  describe "formatted_address/2" do
    test "it returns the address with house number followed by postcode" do
      address = %Address{postcode: "SW3 3T5", house_number: 10}
      assert AddressResolver.formatted_address(address, %{}, %{}) == {:ok, "10 SW3 3T5"}
    end

    test "when there is a blank postcode, we just return the house number" do
      address = %Address{postcode: nil, house_number: 10}
      assert AddressResolver.formatted_address(address, %{}, %{}) == {:ok, "10 "}
    end

    test "when there is no house number, we just return the postcode" do
      address = %Address{postcode: "SW3 3T5", house_number: nil}
      assert AddressResolver.formatted_address(address, %{}, %{}) == {:ok, " SW3 3T5"}
    end
  end
end
