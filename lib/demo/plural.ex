defmodule Demo.Plural do
  @behaviour Gettext.Plural

  def nplurals("elv"), do: 3

  def plural("elv", 0), do: 0
  def plural("elv", 1), do: 1
  def plural("elv", _), do: 2

  # Fall back to Gettext.Plural
  defdelegate nplurals(locale), to: Gettext.Plural
  defdelegate plural(locale, n), to: Gettext.Plural
end
