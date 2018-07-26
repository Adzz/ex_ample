defmodule LandRegData do
  @moduledoc """
  Kids.

  Don't do this at home.

  DISCLAIMER: This is not a good data source, it is not efficient or particularly robust.

  It's being used to make teaching a course easier (no faff with db setup). Thats all.
  """
  use GenServer
  # Could parse this in as csv or JSON
  @starting_data [
    %{
      id: 1,
      house_number_or_name: "1",
      postcode: "PO2 OAP",
      sale_price: 200_000,
      date_sold: ~D[1975-05-05]
    },
    %{
      id: 2,
      house_number_or_name: "1",
      postcode: "PO2 OAP",
      sale_price: 300_000,
      date_sold: ~D[1980-05-05]
    },
    %{
      id: 3,
      house_number_or_name: "2",
      postcode: "SW7 1AZ",
      sale_price: 500_000,
      date_sold: ~D[2010-05-05]
    }
  ]
  # could parse this from CSV headers
  @columns MapSet.new([:id, :sale_price, :postcode, :house_number_or_name, :date_sold])

  ## Client API

  @doc """
  Starts the genserver with @data inside it.
  """
  def start_link(_) do
    GenServer.start_link(__MODULE__, @starting_data, name: __MODULE__)
  end

  @doc """
  Returns all the rows for which have the given attributes
  """
  def get(server, args) do
    GenServer.call(server, {:get, args})
  end

  @doc """
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
    {:reply, DB.Utils.get_by_attrs(data, attrs, @columns), data}
  end

  @impl true
  def handle_cast({:update, record, changes}, data) do
    updated_record = DB.Utils.update_record(record, changes, @columns, data)

    case updated_record do
      {:error, error} -> IO.inspect(error)
      _ -> {:noreply, updated_record}
    end
  end
end
