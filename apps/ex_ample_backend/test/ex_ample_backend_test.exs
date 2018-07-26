defmodule ExAmpleBackendTest do
  use ExUnit.Case
  doctest ExAmpleBackend

  test "greets the world" do
    assert ExAmpleBackend.hello() == :world
  end
end
