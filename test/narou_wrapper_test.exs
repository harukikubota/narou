defmodule NarouWrapperTest do
  use ExUnit.Case
  doctest NarouWrapper

  test "greets the world" do
    assert NarouWrapper.hello() == :world
  end
end
