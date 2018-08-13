defmodule Address do
  @moduledoc """
  Kids.

  Don't do this at home.

  DISCLAIMER: This is not a good data source, it is not efficient or particularly robust.

  It's being used to make teaching a course easier (no faff with db setup). Thats all.
  """
  use GenServer

  @data_path Path.expand(Application.fetch_env!(:ex_ample_backend, :address_source_path))
  # could parse this from CSV headers?
  @columns %{
    id: :string,
    postcode: :string,
    house_number: :number
  }
  @column_set MapSet.new(Map.keys(@columns))
  # this should be defined into a behaviour for all data sources
  # as we rely on it
  def column_set, do: @column_set

  defstruct Map.keys(@columns)

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
  Returns all the rows
  """
  def all(server) do
    GenServer.call(server, {:all})
  end

  @doc """
  Updates the given record inside the data in the genserver with the given changes.

  Yells if you you try and update attributes that the record doesn't have.
  """
  def update(server, record, changes) do
    GenServer.call(server, {:update, record, changes})
  end

  @doc "Creates a record with the attrs and puts it in the db"
  def create(server, datum) do
    GenServer.call(server, {:create, datum})
  end

  @doc "removes the given record from the db. Does nothing if it isn't there already"
  def delete(server, record = %__MODULE__{}) do
    GenServer.call(server, {:delete, record})
  end

  @doc "Truncates the data in the DB"
  def delete_all(server) do
    GenServer.call(server, {:delete_all})
  end

  ## Server Callbacks

  @impl true
  def init(stuff) do
    {:ok, stuff}
  end

  @impl true
  def handle_call({:get, attrs}, _from, data) do
    if DB.Utils.attrs_exist_on_model?(attrs, __MODULE__) do
      {:reply, {:ok, DB.Utils.query_for_attrs(data, attrs)}, data}
    else
      {:error, "You are querying for an attribute that doesn't exist on the data! :("}
    end
  end

  @impl true
  def handle_call({:update, record, changes}, _from, data) do
    with {:ok, updated_record} <- DB.Utils.apply_changes(record, changes),
         {:ok, updated_data} <- DB.Utils.update_record_in_data(record, updated_record, data),
         :ok <- write_to_file(updated_data) do
      {:reply, {:ok, updated_record}, updated_data}
    else
      error -> IO.inspect(error)
    end
  end

  @impl true
  def handle_call({:create, datum}, _from, data) do
    with {:ok, new_record} <- DB.Utils.apply_changes(%__MODULE__{id: UUID.uuid1()}, datum) do
      updated_data = [new_record | data]
      write_to_file(updated_data)

      {:reply, {:ok, new_record}, updated_data}
    else
      error -> IO.inspect(error)
    end
  end

  @impl true
  def handle_call({:all}, _from, data) do
    {:reply, {:ok, data}, data}
  end

  @impl true
  def handle_call({:delete, record}, _from, data) do
    new_data =
      data
      |> Enum.filter(&Map.equal?(&1, record))
      |> write_to_file()

    {:reply, {:ok, record}, new_data}
  end

  @impl true
  def handle_call({:delete_all}, _from, _data) do
    file = File.open!(@data_path, [:write, :utf8])

    [Map.keys(@columns)]
    |> CSV.Encoding.Encoder.encode()
    |> Enum.each(&IO.write(file, &1))

    {:reply, {:ok, :everything_deleted!}, []}
  end

  defp starting_data() do
    @data_path
    |> File.stream!()
    |> CSV.decode!(headers: true)
    |> Enum.map(&atomize_keys/1)
    |> Enum.map(&transform_to_struct/1)
  end

  defp transform_to_struct(data) when is_map(data) do
    struct!(__MODULE__, cast_data(data))
  end

  defp atomize_keys(map) when is_map(map) do
    for {k, v} <- map, do: {String.to_existing_atom(k), v}, into: %{}
  end

  defp write_to_file(data) do
    file = File.open!(@data_path, [:write, :utf8])

    data
    |> Enum.map(&Map.from_struct(&1))
    |> CSV.Encoding.Encoder.encode(headers: true)
    |> Enum.each(&IO.write(file, &1))

    :ok
  end

  defp cast_data(data) do
    for {key, value} <- data,
        do: {key, format_data(value, Map.fetch!(@columns, key))},
        into: %{}
  end

  defp format_data(nil, _), do: nil
  defp format_data("", type) when type not in [:string], do: nil
  defp format_data(datum, :number), do: String.to_integer(datum)
  defp format_data(datum, :date), do: Date.from_iso8601!(datum)
  defp format_data(datum, :string), do: datum
end
