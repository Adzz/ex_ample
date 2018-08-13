defmodule AddressResolver do
  def formatted_address(%Address{postcode: postcode, house_number: house_number}, _args, _info) do
    # implement your function here. Beware, there are unit
    # tests for this funciton in graphql/test/lib/resolvers/address_resolver_test.exs
    # they should also be green!
    {:ok, "#{house_number} #{postcode}"}
  end
end
