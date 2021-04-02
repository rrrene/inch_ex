defmodule InchEx.Application do
  use Application

  def start(_type, _args) do
    children = [
      InchEx.UI.Shell
    ]

    opts = [strategy: :one_for_one, name: InchEx.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
