defmodule InchTestWeb.PageController do
  use InchTestWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
