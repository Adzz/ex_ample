defmodule DB do
  @moduledoc """
  Use this module to query our homemade database.

  If the words 'homemade database' fill you with fear, that's a good sign.
  """

  @data_sources [
    Address,
    LandRegData
  ]

  @doc """
  Returns all the data from the given data source that matches the given attributes.

  Returns {:error, "Not found"} if there is no match.

  ### Examples

      iex> DB.get(LandRegData, postcode: "PO2 OAP", house_number_or_name: 1)
      [%LandRegData{id: 1, house_number_or_name: "1", postcode: "PO2 OAP", sale_price: 200_000, date_sold: ~D[1975-05-05]}]
  """
  @spec get(atom(), map | list(any)) :: {:ok, list(map)} | {:error, binary()}
  def get(data_source, attrs) do
    data_source.get(data_source, attrs)
  end

  @doc """
  Updates the given record to have the changes supplied. Returns the updated record

  ### Examples

      iex> record = DB.get(LandRegData, postcode: "PO2 OAP", house_number_or_name: 1) |> hd
      ...> DB.update(record, sale_price: 40)
      %LandRegData{id: 1, house_number_or_name: "1", postcode: "PO2 OAP", sale_price: 40, date_sold: ~D[1975-05-05]}

  """
  def update(record, changes) do
    data_source = record.__struct__
    data_source.update(data_source, record, changes)
  end

  @doc """
  Creates a record based on the given data, creates a unique id for the created record and returns the created record

  ### Examples

      iex> DB.create(LandRegData, %{sale_price: 50})
      %LandRegData{id: "54321", house_number_or_name: nil, postcode: nil, sale_price: 50, date_sold: nil}

  """
  def create(data_source, data) do
    data_source.create(data_source, data)
  end

  @doc """
  Returns all the data in the given data source. So you know, go careful. Useful for debuggin I guess

  ### Examples

    iex> DB.all(LandRegData)
    [... loads of data ...]

  """
  def all(data_source) do
    data_source.all(data_source)
  end

  @doc """
  Deletes the given record from within data_source.

  ### Examples

      iex> record = DB.get(LandRegData, postcode: "PO2 OAP", house_number_or_name: 1) |> hd
      ...> DB.delete(record)
  """
  def delete(record) do
    data_source = record.__struct__
    data_source.delete(data_source, record)
  end

  @doc """
  Deletes all of the data contained in the data source.

  Useful between test runs.

  ### Examples

      iex> DB.delete_all(LandRegData)
  """
  def delete_all(data_source) do
    data_source.delete_all(data_source)
  end

  @doc """
  Truncates all of the data sources in the app. This is only useful for tests, probably dont run on
  prod...

  If you add a data source, ensure you add to @data_sources to keep the tests clear between runs
  """
  def reset_db() do
    for data_source <- @data_sources do
      DB.delete_all(data_source)
    end
  end
end
