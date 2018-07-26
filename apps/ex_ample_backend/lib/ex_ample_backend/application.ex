defmodule ExAmpleBackend.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {DB.Supervisor, []}
    ]

    opts = [strategy: :one_for_one, name: ExAmpleBackend.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
