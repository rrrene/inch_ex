defmodule InchEx.Reporter do

  def handle_success(output) do
    # is this really the only way to binwrite to stdout?
    {:ok, pid} = StringIO.open("")
    IO.binwrite pid, output
    {_, contents} = StringIO.contents(pid)
    StringIO.close pid
    IO.write contents
    {:ok, contents}
  end

  def handle_error(output) do
    IO.puts output
    {:error, output}
  end
end
