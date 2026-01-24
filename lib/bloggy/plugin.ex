defmodule Bloggy.Plugin do
  @moduledoc """
  Defines the behaviour for Bloggy plugins.
  Plugins can hook into lifecycle events to extend functionality.
  """

  @callback name() :: String.t()
  @callback init(config :: keyword()) :: {:ok, map()} | {:error, any()}
  @callback handle_event(event :: atom(), payload :: map(), state :: map()) :: {:ok, map()} | {:noreply, map()}

  defmacro __using__(_opts) do
    quote do
      @behaviour Bloggy.Plugin

      def init(_config), do: {:ok, %{}}
      def handle_event(_event, _payload, state), do: {:noreply, state}
      
      defoverridable init: 1, handle_event: 3
    end
  end
end
