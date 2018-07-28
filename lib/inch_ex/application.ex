defmodule InchEx.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(InchEx.UI.Shell, [])
    ]

    opts = [strategy: :one_for_one, name: InchEx.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
