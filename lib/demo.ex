defmodule Demo do
  @moduledoc """
  Documentation for `Demo`.
  """

  import Demo.Gettext

  @doc """
  Hello world.

  ## Examples

      iex> Demo.hello()
      "hello!"

  """
  def hello do
    gettext("hello!")
  end
end
