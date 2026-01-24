defmodule Bloggy.PluginManager do
  use GenServer
  require Logger

  # Client API

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def register_plugin(module, config \\ []) do
    GenServer.call(__MODULE__, {:register, module, config})
  end

  def broadcast_event(event, payload) do
    GenServer.cast(__MODULE__, {:broadcast, event, payload})
  end

  # Server Callbacks

  @impl true
  def init(_opts) do
    # Load default plugins from config or keep empty
    {:ok, %{plugins: %{}}}
  end

  @impl true
  def handle_call({:register, module, config}, _from, state) do
    case module.init(config) do
      {:ok, plugin_state} ->
        Logger.info("Plugin registered: #{module.name()}")
        new_plugins = Map.put(state.plugins, module, plugin_state)
        {:reply, :ok, %{state | plugins: new_plugins}}

      {:error, reason} ->
        Logger.error("Failed to register plugin #{module}: #{inspect(reason)}")
        {:reply, {:error, reason}, state}
    end
  end

  @impl true
  def handle_cast({:broadcast, event, payload}, state) do
    new_plugins = 
      Enum.reduce(state.plugins, state.plugins, fn {module, plugin_state}, acc ->
        case module.handle_event(event, payload, plugin_state) do
          {:ok, new_state} -> Map.put(acc, module, new_state)
          {:noreply, _} -> acc
          _ -> acc
        end
      end)
    
    {:noreply, %{state | plugins: new_plugins}}
  end
end
