defmodule DB.Supervisor do
  @moduledoc """
  Supervisor for the DB, ensures the DB is restarted in the case of a crash
  """
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    children = [
      {LandRegData, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
