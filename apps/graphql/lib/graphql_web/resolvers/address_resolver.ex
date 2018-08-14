defmodule AddressResolver do
  def formatted_address(%Address{postcode: postcode, house_number: house_number}, _args, _info) do
    {:ok, "#{house_number} #{postcode}"}
  end
end
