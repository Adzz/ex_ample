defmodule DB do
  @moduledoc """
  Use this module to query our homemade database.

  If the words 'homemade database' fill you with fear, that's a good sign.
  """

  @doc """
  Returns all the data from the given data source that matches the given attributes

  ### Examples
      iex>DB.get(LandRegData, postcode: "PO2 OAP", house_number_or_name: 1)
      %{id: 1, house_number_or_name: "1", postcode: "PO2 OAP", sale_price: 200_000, date_sold: ~D[1975-05-05]}
  """
  def get(data_source, attrs) do
    data_source.get(data_source, attrs)
  end

  @doc "Updates the given record to have the changes supplied. Returns the updated record"
  def update(record, changes) do
    data_source = record.module
    data_source.update(data_source, record, changes)
    get(data_source, changes)
  end
end
