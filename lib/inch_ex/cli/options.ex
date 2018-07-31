defmodule InchEx.CLI.Options do
  @switches [
    all: :boolean
    # color: :boolean,
    # debug: :boolean,
    # mute_exit_status: :boolean,
    # format: :string,
    # help: :boolean,
    # ignore: :string,
    # only: :string,
    # read_from_stdin: :boolean,
    # strict: :boolean,
    # version: :boolean
  ]
  @aliases [
    a: :all
    # d: :debug,
    # h: :help,
    # v: :version
  ]

  defstruct path: nil,
            all: nil,
            args: nil,
            switches: nil,
            unknown_switches: nil

  def parse(argv) do
    argv
    |> OptionParser.parse(strict: @switches, aliases: @aliases)
    |> parse_result()
  end

  defp parse_result({switches_keywords, unknown_args, unknown_switches_keywords}) do
    %__MODULE__{
      path: Mix.Project.compile_path(),
      args: unknown_args,
      switches: Enum.into(switches_keywords, %{}),
      unknown_switches: unknown_switches_keywords
    }
  end
end
