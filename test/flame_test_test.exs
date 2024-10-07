defmodule FlameTestTest do
  use ExUnit.Case
  doctest FlameTest

  test "greets the world" do
    assert FlameTest.hello() == :world
  end
end
