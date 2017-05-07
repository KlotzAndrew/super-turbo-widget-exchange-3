defmodule WebApi.WidgetTest do
  use WebApi.ModelCase

  alias WebApi.Widget

  @valid_attrs %{token: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Widget.changeset(%Widget{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Widget.changeset(%Widget{}, @invalid_attrs)
    refute changeset.valid?
  end
end
