defmodule ExmlTranslator.FileGenserver do
  use GenServer
  require Logger

  @name __MODULE__
  @timeout 5_000

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: @name)
  end

  def write(pid, filename, data) do
    GenServer.call(@name, {:write, pid, filename, data}, @timeout)
  end

  def close(pid, filename) do
    GenServer.call(@name, {:close, pid, filename}, @timeout)
  end

  def handle_call({:write, pid, filename, data}, _from, state) do
    {file_handler, state} = get_file_stream(pid, filename, state)
    {:reply, IO.write(file_handler, data), state}
  end

  def handle_call({:close, pid, filename}, _from, state) do
    {file_handler, state} = get_file_stream(pid, filename, state)

    {status, result, state} = case File.close(file_handler) do
      :ok -> {:ok, :ok, Kernel.put_in(state, [pid, filename], nil)}
      {:error, error} -> {:error, error, state}
    end

    {:reply, {status, result}, state}
  end

  def get_file_stream(pid, filename, state) do
    state = case Map.get(state, pid) do
      nil -> Map.put(state, pid, %{})
      _ -> state
    end

    {handler, state} = case Kernel.get_in(state, [pid, filename]) do
      nil ->
        handler = File.open!(filename, [:append, :utf8])
        {handler, Kernel.put_in(state, [pid, filename], handler)}
      handler ->
        {handler, state}
    end

    {handler, state}
  end

end
