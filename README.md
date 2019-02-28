# ExAmple

## My first resolving function - answers

Here's our solution for the address formatter:

```elixir
defmodule AddressResolver do
  def formatted_address(%Address{postcode: postcode, house_number: house_number}, _args, _info) do
    {:ok, "#{house_number} #{postcode}"}
  end
end
```

We pattern matched the args and used string interpolation to make this tidy, but there's several ways you could have achieved the same result.

# The End

Enjoy this workshop? Great! Spotted spelling mistakes? Want to update stuff? PRs always welcome 👍🏼

