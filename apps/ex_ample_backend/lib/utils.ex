defmodule DB.Utils do
  def update_record(record, changes, columns, data) do
    changes_keys = List.foldr(changes, [], fn {key, _}, acc -> [key | acc] end) |> MapSet.new()

    if MapSet.subset?(changes_keys, columns) do
      index =
        Enum.with_index(data)
        |> Enum.filter(fn {x, _} -> Map.equal?(x, record) end)
        |> Enum.map(fn {_, i} -> i end)
        |> hd()

      {:ok,
       List.update_at(data, index, fn record -> Map.merge(record, Enum.into(changes, %{})) end)}
    else
      {:error, "You are trying to change a column that doesn't exist on the data! :("}
    end
  end

  def get_by_attrs(data, attrs, columns) when is_list(attrs) do
    attribute_keys = List.foldr(attrs, [], fn {key, _}, acc -> [key | acc] end) |> MapSet.new()

    if MapSet.subset?(attribute_keys, columns) do
      query_for_attrs(data, attrs)
    else
      "You are querying for an attribute that doesn't exist on the data! :("
    end
  end

  defp query_for_attrs(data, attrs) do
    query_for_attrs(data, attrs, List.first(attrs))
  end

  defp query_for_attrs(data, attrs, {attr_name, attr_value}) when length(attrs) > 0 do
    new_data = Enum.filter(data, fn datum -> Map.fetch!(datum, attr_name) == attr_value end)
    query_for_attrs(new_data, Enum.drop(attrs, 1), List.first(attrs))
  end

  defp query_for_attrs(data, _, _), do: data
end
