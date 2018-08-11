defmodule DB.Utils do
  def update_record_in_data(record, updated_record, data) do
    index = location_of_record_in_data(record, data)
    {:ok, List.update_at(data, index, fn _ -> updated_record end)}
  end

  def location_of_record_in_data(record, data) when is_list(data) do
    Enum.with_index(data)
    |> Enum.filter(fn {x, _index} -> Map.equal?(x, record) end)
    |> Enum.map(fn {_record, i} -> i end)
    |> hd()
  end

  def apply_changes(old_record, changes) when is_list(changes) do
    if attrs_exist_on_model?(changes, old_record.__struct__) do
      {:ok, Map.merge(old_record, Enum.into(changes, %{}))}
    else
      {:error, "You are trying to change a column that doesn't exist! :("}
    end
  end

  def apply_changes(old_record, changes) when is_map(changes) do
    if attrs_exist_on_model?(changes, old_record.__struct__) do
      {:ok, Map.merge(old_record, changes)}
    else
      {:error, "You are trying to change a column that doesn't exist! :("}
    end
  end

  def attrs_exist_on_model?(attrs, model) when is_list(attrs) do
    attr_keys = List.foldr(attrs, [], fn {key, _}, acc -> [key | acc] end) |> MapSet.new()
    MapSet.subset?(attr_keys, model.column_set)
  end

  def attrs_exist_on_model?(attrs, model) when is_map(attrs) do
    attrs
    |> Map.keys()
    |> MapSet.new()
    |> MapSet.subset?(model.column_set)
  end

  def query_for_attrs(data, attrs) when is_map(attrs) do
    query_for_attrs(data, Map.to_list(attrs))
  end

  def query_for_attrs(data, attrs) when is_list(attrs) do
    query_for_attrs(data, attrs, List.first(attrs))
  end

  def query_for_attrs(data, attrs, {attr_name, attr_value}) when length(attrs) > 0 do
    Enum.filter(data, fn datum -> Map.fetch!(datum, attr_name) == attr_value end)
    |> case do
      [] -> {:error, "No record found with those attrs!"}
      results -> query_for_attrs(results, Enum.drop(attrs, 1), List.first(attrs))
    end
  end

  def query_for_attrs(data, _, _), do: data
end
