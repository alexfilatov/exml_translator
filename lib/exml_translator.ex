defmodule ExmlTranslator do
  require Logger
  @moduledoc """
  Documentation for ExmlTranslator.
  """
  @chunk 10000
  def locale(), do: "de"
  def out_filename(), do: "output.xml"


  def run(in_file, out_file, locale, attrs_to_translate \\ []) do
    {:ok, in_handle} = File.open(in_file, [:binary])
    position           = 0
    c_state            = {in_handle, position, @chunk}

    ExmlTranslator.FileGenserver.start_link()
    ExmlTranslator.FileGenserver.write(self(), out_filename(), ~s(<?xml version="1.0" encoding="utf-8"?>))

    :erlsom.parse_sax("", nil, &sax_event_handler/2, [{:continuation_function, &continue_file/2, c_state}])
    :ok = File.close(in_handle)
  end

  def continue_file(tail, {in_handle, offset, chunk}) do
    case :file.pread(in_handle, offset, chunk) do
      {:ok, data} ->
        {<<tail :: binary, data::binary>>, {in_handle, offset + chunk, chunk}}
      :oef ->
        {tail, {in_handle, offset, chunk}}
    end
  end

  def xml_writer(data) do
    ExmlTranslator.FileGenserver.write(self(), out_filename(), data)
  end

  def sax_event_handler({:startElement, _uri, tag, _prefix, attrs}, state) do
    state = state || %{}
    state = Map.put(state, "tag_name", to_string(tag))

    attrs_str = if Kernel.length(attrs) > 0 do
      Enum.reduce(attrs, [], fn({_attribute, attr_name, _, _, value}, acc) ->
        attr_name = to_string(attr_name)
        value = to_string(value)
        value = if Enum.member?(["name", "unit"], attr_name) do
          Logger.debug "attr :: [#{inspect value}]"
          {:ok, value} = ExmlTranslator.Translator.translate_to_locale(value, locale())
          value
        else
          value
        end

        acc ++ ["#{attr_name}=\"#{value}\""]
      end)
      |> Enum.join(" ")
      |> (fn(s) -> " " <> s end).()
    else
      ""
    end

    xml_writer("<#{tag}#{attrs_str}>")
    state
  end


  def sax_event_handler({:characters, value}, state) do
    value = to_string(value)
    |> String.trim()
    |> String.replace(~r/\n+/, "\n")
    |> String.replace(~r/\s+/, " ")

    tag_name = state["tag_name"]
    if Enum.member?(["name", "description", "param", "vendor"], tag_name) do
      {:ok, value} = ExmlTranslator.Translator.translate_to_locale(value, locale())
      value
    else
      value
    end
    |> xml_writer()

    state
  end

  def sax_event_handler({:endElement, _, tag, _}, state) do
    xml_writer("</#{tag}>")
    state
  end


  def sax_event_handler(:endDocument, state) do
    ExmlTranslator.FileGenserver.close(self(), out_filename())
    state
  end
  def sax_event_handler(_, state), do: state



end
