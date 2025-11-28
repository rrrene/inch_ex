defmodule InchTest do
  @moduledoc """
  InchTest keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @enforce_keys [:count, :leds, :opts]
  defstruct count: 0, leds: %{}, opts: %{}, meta: %{index: 1}

  @typedoc """
  The structure defining an led sequence.
  """
  @type t :: %__MODULE__{
          count: integer,
          leds: %{pos_integer => Types.colorint()},
          opts: %{atom => any},
          meta: %{atom => any}
        }

  @doc delegate_to: {InchTest, :leds, 0}
  defdelegate some_delegated_doc(), to: InchTest, as: :leds
  @doc delegate_to: {InchTest, :leds, 1}
  defdelegate some_delegated_doc(count), to: InchTest, as: :leds
  @doc delegate_to: {InchTest, :leds, 2}
  defdelegate some_delegated_doc(count, opts), to: InchTest, as: :leds
  @doc delegate_to: {InchTest, :leds, 3}
  defdelegate some_delegated_doc(count, leds, opts), to: InchTest, as: :leds
  @doc delegate_to: {InchTest, :leds, 4}
  defdelegate some_delegated_doc(count, leds, opts, meta), to: InchTest, as: :leds

  @doc """
  Create a new led sequence of length 0.

  This is rarely useful. Use the `leds/1` function instead (or change the count by using `set_count/2`)
  """
  @spec leds() :: t
  def leds do
    leds(0)
  end

  @doc """
  Creates a new led sequence with a set number of leds
  """
  @spec leds(integer) :: t
  def leds(count) do
    leds(count, %{})
  end

  @doc """
  Create a new led sequence with a set number of leds and some options.

  Currently two options are available:

  * `:server_name` and
  * `:namespace`.

  Those are important when you want to send your led sequence to an
  `Fledex.LedStrip`.
  You should prefer to use the `set_led_strip_info/3` function instead.
  """
  @spec leds(integer, map) :: t
  def leds(count, opts) do
    leds(count, %{}, opts)
  end

  @doc """
  Create a new led sequence with a set number of leds, some set leds and options.

  This function is similar to `leds/2`, but you  an specify some leds (between the `count`
  and the `opts`) through a map or a list.

  If a map is used the key of the map (an integer) is the index (one-indexed) of the
  led and the value is the color.
  If a list is used each entry in the list defines a color. Internally it will be converted
  to a map.

  Leds that are outside the `count` can be specified, but will be ignored when sent to
  an `Fledex.LedStrip` through the `send/2` function.
  """
  @spec leds(integer, list(Types.color()) | %{integer => Types.color()}, map) :: t
  def leds(count, leds, opts) do
    leds(count, leds, opts, %{})
  end

  @doc """
  Creates a led sequence with a set number of leds, some set leds, some options and some
  meta information.

  This function is similar to the `leds/3` function, but some additional meta information
  can be specified. Currently the only  meta information is to keep track of an index
  that specfies which led will be set when using the `light/2` function, i.e. without
  an offset. This way it's possible to have a sequence of updates like the following
  to specify the colors:

  ```elixir
  leds(10) |> light(:red) |> light(:blue)
  ```
  """
  @spec leds(integer, list(Types.color()) | %{integer => Types.color()}, map, map) :: t
  def leds(_count, leds, _opts, _meta) when is_list(leds) do
    nil
  end

  def leds(_count, leds, _opts, _meta) when is_map(leds) do
    nil
  end

  @doc """
  This is a test if macros are recognized.
  """
  defmacro some_macro(_) do
    nil
  end

  defmodule SomeGenServer do
    use GenServer

    # Callbacks

    def start_link(default) when is_binary(default) do
      GenServer.start_link(__MODULE__, default)
    end

    def child_spec(init_arg) do
      %{
        id: __MODULE__,
        start: {__MODULE__, :start_link, [init_arg]}
      }
    end

    @impl true
    def init(stack) do
      {:ok, stack}
    end

    @impl true
    def handle_call(:pop, _from, [head | tail]) do
      {:reply, head, tail}
    end

    @impl true
    def handle_cast({:push, element}, state) do
      {:noreply, [element | state]}
    end
  end
end
