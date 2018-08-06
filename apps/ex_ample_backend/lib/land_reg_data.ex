defmodule LandRegData do
  @moduledoc """
  Kids.

  Don't do this at home.

  DISCLAIMER: This is not a good data source, it is not efficient or particularly robust.

  It's being used to make teaching a course easier (no faff with db setup). Thats all.
  """
  use GenServer

  @data_path "apps/ex_ample_backend/lib/data/source.csv"
  # could parse this from CSV headers?
  @columns %{
    id: :number,
    sale_price: :number,
    postcode: :string,
    house_number: :number,
    date_sold: :date
  }
  @column_set MapSet.new(Map.keys(@columns))
  defstruct Map.keys(@columns) ++ [module: __MODULE__]

  ## Client API

  @doc """
  Starts the genserver with @data inside it.
  """
  def start_link(_) do
    GenServer.start_link(__MODULE__, starting_data(), name: __MODULE__)
  end

  @doc """
  Returns all the rows for which have the given attributes
  """
  def get(server, args) do
    GenServer.call(server, {:get, args})
  end

  @doc """
  Updates the given record inside the data in the genserver with the given changes.

  Yells if you you try and update attribues that the record doesn't have.
  """
  def update(server, record, changes) do
    GenServer.cast(server, {:update, record, changes})
  end

  ## Server Callbacks

  @impl true
  def init(stuff) do
    {:ok, stuff}
  end

  @impl true
  def handle_call({:get, attrs}, _from, data) do
    {:reply, DB.Utils.get_by_attrs(data, attrs, @column_set), data}
  end

  @impl true
  def handle_cast({:update, record, changes}, data) do
    with {:ok, updated_data} <- DB.Utils.update_record(record, changes, @column_set, data),
         :ok <- write_to_file(updated_data) do
      {:noreply, updated_data}
    else
      error -> IO.inspect(error)
    end
  end

  defp starting_data() do
    @data_path
    |> File.stream!()
    |> CSV.decode!(headers: true)
    |> Enum.map(&atomize_keys/1)
    |> Enum.map(&transform_to_struct/1)
  end

  def transform_to_struct(data) when is_map(data) do
    struct(__MODULE__, cast_data(data))
  end

  def atomize_keys(map) when is_map(map) do
    for {k, v} <- map, do: {String.to_existing_atom(k), v}, into: %{}
  end

  def write_to_file(data) do
    file = File.open!(@data_path, [:write, :utf8])

    data
    |> Enum.map(&Map.from_struct(&1))
    |> Enum.map(&Map.drop(&1, [:module]))
    |> CSV.Encoding.Encoder.encode(headers: true)
    |> Enum.each(&IO.write(file, &1))

    :ok
  end

  def cast_data(data) do
    for {key, value} <- Map.drop(data, [:module]),
        do: {key, format_data(value, Map.fetch!(@columns, key))},
        into: %{}
  end

  def format_data(datum, :number), do: String.to_integer(datum)
  def format_data(datum, :date), do: Date.from_iso8601!(datum)
  def format_data(datum, :string), do: datum
end
